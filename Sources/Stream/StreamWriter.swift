/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol StreamWriter: class {
    func write(_ byte: UInt8) throws
    func write<T: BinaryInteger>(_ value: T) throws
    func write(_ bytes: [UInt8]) throws
    func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws
    func flush() throws
}

extension StreamWriter {
    public func write(_ bytes: UnsafeRawBufferPointer) throws {
        try write(bytes.baseAddress!, byteCount: bytes.count)
    }

    public func write(_ bytes: [UInt8]) throws {
        try write(bytes, byteCount: bytes.count)
    }

    public func write(_ string: String) throws {
        try write([UInt8](string.utf8))
    }
}

public protocol StreamWritable {
    func write(to stream: StreamWriter) throws
}
