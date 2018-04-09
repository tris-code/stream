/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

// Convenience conformance

extension OutputByteStream: StreamWriter {
    public var buffered: Int {
        return bytes.count - position
    }

    public func write(_ byte: UInt8) throws {
        bytes.append(byte)
    }

    public func write<T: FixedWidthInteger>(_ value: T) throws {
        var value = value.bigEndian
        withUnsafeBytes(of: &value) { buffer in
            bytes.append(contentsOf: buffer)
        }
    }

    public func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws {
        var written = 0
        while written < byteCount {
            let count = try write(from: bytes, byteCount: byteCount)
            guard count > 0 else {
                throw StreamError.insufficientData
            }
            written += count
        }
    }

    public func flush() throws {
        // nop
    }
}
