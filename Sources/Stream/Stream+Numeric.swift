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
    public func read<T: BinaryInteger>(_ type: T.Type) throws -> T {
        var result: T = 0
        try withUnsafeMutableBytes(of: &result) { bytes in
            guard try read(to: bytes) == MemoryLayout<T>.size else {
                throw StreamError.insufficientData
            }
        }
        return result
    }
}

extension OutputStream {
    @inline(__always)
    public func write<T: BinaryInteger>(_ value: T) throws {
        var value = value
        try withUnsafeBytes(of: &value) { bytes in
            guard try write(bytes) == MemoryLayout<T>.size else {
                throw StreamError.insufficientData
            }
        }
    }
}
