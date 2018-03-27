/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension BufferedInputStream: StreamReader {}

extension BufferedInputStream {
    public func cache(count: Int) throws -> Bool {
        if count > buffered {
            try ensure(count: count)
            guard try feed() && buffered >= count else {
                return false
            }
        }
        return true
    }

    @_inlineable
    public func next<T>(is elements: T) throws -> Bool
        where T : Collection, T.Element == UInt8
    {
        let count = elements.count
        if count > buffered {
            try ensure(count: count)
            guard try feed() && buffered >= count else {
                throw StreamError.insufficientData
            }
        }

        let buffer = UnsafeRawBufferPointer(start: readPosition, count: count)
        return buffer.elementsEqual(elements)
    }
}

extension BufferedInputStream {
    @_inlineable // optimized
    public func read(_ type: UInt8.Type) throws -> UInt8 {
        if buffered == 0 {
            guard try feed() else {
                throw StreamError.insufficientData
            }
        }
        let byte = readPosition
            .assumingMemoryBound(to: UInt8.self)
            .pointee
        readPosition += 1
        return byte
    }

    @_inlineable
    public func read<T: BinaryInteger>(_ type: T.Type) throws -> T {
        var result: T = 0
        try withUnsafeMutableBytes(of: &result) { pointer in
            pointer.copyMemory(from: try _read(count: MemoryLayout<T>.size))
        }
        return result
    }

    @_versioned
    func _read(count: Int) throws -> UnsafeRawBufferPointer {
        if count > buffered {
            if count > allocated {
                try ensure(count: count)
            } else {
                try ensure(count: count - buffered)
            }

            while buffered < count, try feed() {}

            guard count <= buffered else {
                throw StreamError.insufficientData
            }
        }
        defer { readPosition += count }
        return UnsafeRawBufferPointer(start: readPosition, count: count)
    }

    @_inlineable
    public func read(count: Int) throws -> [UInt8] {
        return [UInt8](try _read(count: count))
    }

    @_inlineable
    public func read<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try body(try _read(count: count))
    }

    @_versioned
    func _read(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool = true) throws -> UnsafeRawBufferPointer
    {
        var read = 0
        defer { readPosition += read }
        while true {
            if read == buffered {
                try ensure(count: 1)
                guard try feed() else {
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

    @_inlineable
    public func read(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool = true) throws -> [UInt8]
    {
        let buffer = try _read(
            while: predicate,
            allowingExhaustion: allowingExhaustion)
        return [UInt8](buffer)
    }

    @_inlineable
    public func read<T>(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        let buffer = try _read(
            while: predicate,
            allowingExhaustion: allowingExhaustion)
        return try body(buffer)
    }
}

extension BufferedInputStream {
    public func consume(count: Int) throws {
        guard buffered < count else {
            readPosition += count
            return
        }

        var rest = count - buffered
        flush()

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
            guard try feed() else {
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
        allowingExhaustion: Bool = true) throws
    {
        while true {
            if buffered == 0 {
                guard try feed() else {
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
    func feed() throws -> Bool {
        guard used < allocated else {
            throw StreamError.notEnoughSpace
        }
        let read = try baseStream.read(
            to: writePosition,
            byteCount: allocated - used)
        guard read > 0 else {
            return false
        }
        writePosition += read
        return true
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
