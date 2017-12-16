/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension InputStream {
    @inline(__always)
    public func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int {
        return try read(to: buffer.baseAddress!, byteCount: buffer.count)
    }

    @inline(__always)
    public func read(to buffer: inout ArraySlice<UInt8>) throws -> Int {
        return try buffer.withUnsafeMutableBytes { buffer in
            return try read(to: buffer)
        }
    }

    @inline(__always)
    public func read(to buffer: inout [UInt8]) throws -> Int {
        return try buffer.withUnsafeMutableBytes { buffer in
            return try read(to: buffer)
        }
    }
}

extension OutputStream {
    @inline(__always)
    public func write(_ bytes: UnsafeRawBufferPointer) throws -> Int {
        return try write(bytes.baseAddress!, byteCount: bytes.count)
    }

    @inline(__always)
    public func write(_ bytes: ArraySlice<UInt8>) throws -> Int {
        return try bytes.withUnsafeBytes { buffer in
            return try write(buffer)
        }
    }

    @inline(__always)
    public func write(_ bytes: [UInt8]) throws -> Int {
        return try bytes.withUnsafeBytes { buffer in
            return try write(buffer)
        }
    }
}
