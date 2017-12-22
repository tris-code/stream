/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension BufferedInputStream: UnsafeStreamReader {}

extension BufferedInputStream {
    @_inlineable
    public func peek(count: Int) throws -> UnsafeRawBufferPointer? {
        if count > buffered {
            try ensure(count: count)
            guard try feed() > 0 && buffered >= count else {
                return nil
            }
        }
        return UnsafeRawBufferPointer(start: readPosition, count: count)
    }
}

extension BufferedInputStream {
    public func read() throws -> UInt8 {
        if buffered == 0 {
            guard try feed() > 0 else {
                throw StreamError.insufficientData
            }
        }
        let byte = readPosition
            .assumingMemoryBound(to: UInt8.self)
            .pointee
        readPosition += 1
        return byte
    }

    public func read(count: Int) throws -> UnsafeRawBufferPointer {
        if count > buffered {
            if count > allocated {
                try ensure(count: count)
            } else {
                try ensure(count: count - buffered)
            }

            while buffered < count {
                if try feed() == 0 {
                    break
                }
            }

            guard count <= buffered else {
                throw StreamError.insufficientData
            }
        }
        defer { readPosition += count }
        return UnsafeRawBufferPointer(start: readPosition, count: count)
    }

    @_inlineable
    public func read(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool = true
    ) throws -> UnsafeRawBufferPointer {
        var read = 0
        defer { readPosition += read }
        while true {
            if read == buffered {
                try ensure(count: 1)
                guard try feed() > 0 else {
                    if allowingExhaustion { break }
                    throw StreamError.insufficientData
                }
            }
            let byte = readPosition
                .advanced(by: read)
                .assumingMemoryBound(to: UInt8.self)
                .pointee
            if !predicate(byte) {
                break
            }
            read += 1
        }
        return UnsafeRawBufferPointer(start: readPosition, count: read)
    }
}

extension BufferedInputStream {
    public func consume(count: Int) throws {
        guard buffered < count else {
            readPosition += count
            return
        }

        var rest = count - buffered
        reset()

        if rest > allocated && expandable {
            reallocate(byteCount: rest)
        }

        var read = 0
        while rest > 0 {
            read = try baseStream.read(to: storage, byteCount: allocated)
            rest -= read
        }
        readPosition = storage + (-rest)
        writePosition = storage + read
    }

    public func consume(_ byte: UInt8) throws -> Bool {
        if buffered == 0 {
            guard try feed() > 0 else {
                throw StreamError.insufficientData
            }
        }

        let next = readPosition
            .assumingMemoryBound(to: UInt8.self)
            .pointee

        guard next == byte else {
            return false
        }
        readPosition += 1
        return true
    }

    @_inlineable
    public func consume(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool = true
    ) throws {
        while true {
            if buffered == 0 {
                guard try feed() > 0 else {
                    if allowingExhaustion { return }
                    throw StreamError.insufficientData
                }
            }
            let byte = readPosition.assumingMemoryBound(to: UInt8.self)
            if !predicate(byte.pointee) {
                return
            }
            readPosition += 1
        }
    }
}

extension BufferedInputStream {
    @_versioned
    func feed() throws -> Int {
        guard used < allocated else {
            throw StreamError.notEnoughSpace
        }
        let read = try baseStream.read(
            to: writePosition,
            byteCount: allocated - used)
        writePosition += read
        return read
    }

    @_versioned
    func ensure(count requested: Int) throws {
        guard used + requested > allocated else {
            return
        }

        switch expandable {
        case false:
            guard buffered + requested <= allocated else {
                throw StreamError.notEnoughSpace
            }
            shift()
        case true where buffered + requested <= allocated / 2:
            shift()
        default:
            reallocate(byteCount: (buffered + requested) * 2)
        }
    }

    func shift() {
        let count = buffered
        storage.copyMemory(from: readPosition, byteCount: count)
        readPosition = storage
        writePosition = storage + count
    }

    func reallocate(byteCount: Int) {
        let count = buffered
        let storage = UnsafeMutableRawPointer.allocate(
            byteCount: byteCount,
            alignment: MemoryLayout<UInt>.alignment)
        storage.copyMemory(from: self.readPosition, byteCount: count)
        self.storage.deallocate()
        self.storage = storage
        self.allocated = byteCount
        self.readPosition = storage
        self.writePosition = storage + count
    }
}