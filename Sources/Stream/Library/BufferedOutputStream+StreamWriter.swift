/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension BufferedOutputStream: StreamWriter {
    public func write(_ byte: UInt8) throws {
        if available <= 0 {
            try flush()
        }
        storage.advanced(by: buffered)
            .assumingMemoryBound(to: UInt8.self)
            .pointee = byte
        buffered += 1
    }

    public func write<T: BinaryInteger>(_ value: T) throws {
        var value = value
        return try withUnsafePointer(to: &value) { pointer in
            return try write(pointer, byteCount: MemoryLayout<T>.size)
        }
    }

    public func write(_ buffer: UnsafeRawPointer, byteCount: Int) throws {
        var written = 0
        while written < byteCount {
            let count: Int = try write(from: buffer, byteCount: byteCount)
            guard count > 0 else {
                throw StreamError.insufficientData
            }
            written += count
        }
    }
}