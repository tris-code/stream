/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public enum StreamError: Error {
    case noSpaceAvailable
}

public protocol Stream: InputStream, OutputStream {}

public protocol InputStream {
    func read(to buffer: UnsafeMutableRawPointer, count: Int) throws -> Int
}

public protocol OutputStream {
    func write(from buffer: UnsafeRawPointer, count: Int) throws -> Int
}

extension InputStream {
    public func read(to buffer: UnsafeMutableRawPointer, offset: Int, count: Int) throws -> Int {
        return try read(to: buffer.advanced(by: offset), count: count)
    }
}

extension OutputStream {
    public func write(from buffer: UnsafeRawPointer, offset: Int, count: Int) throws -> Int {
        return try write(from: buffer.advanced(by: offset), count: count)
    }
}
