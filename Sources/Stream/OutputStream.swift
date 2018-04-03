/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol OutputStream {
    func write(from buffer: UnsafeRawPointer, byteCount: Int) throws -> Int
}

extension OutputStream {
    @inline(__always)
    public func write(from buffer: UnsafeRawBufferPointer) throws -> Int {
        return try write(from: buffer.baseAddress!, byteCount: buffer.count)
    }

    @inline(__always)
    public func write(from buffer: ArraySlice<UInt8>) throws -> Int {
        return try buffer.withUnsafeBytes(write)
    }

    @inline(__always)
    public func write(from buffer: [UInt8]) throws -> Int {
        return try buffer.withUnsafeBytes(write)
    }
}

extension OutputStream {
    @inlinable
    public func copyBytes<T: InputStream>(
        from input: T,
        bufferSize: Int = 4096) throws -> Int
    {
        var total = 0
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        while true {
            let read = try input.read(to: &buffer)
            guard read > 0 else {
                return total
            }
            total = total &+ read

            var index = 0
            while index < read {
                let written = try write(from: buffer[index..<read])
                guard written > 0 else {
                    throw StreamError.notEnoughSpace
                }
                index += written
            }
        }
    }
}
