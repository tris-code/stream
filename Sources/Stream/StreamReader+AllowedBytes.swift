/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public final class AllowedBytes {
    @_versioned
    let buffer: UnsafeBufferPointer<Bool>

    public init(byteSet set: Set<UInt8>) {
        let buffer = UnsafeMutableBufferPointer<Bool>.allocate(capacity: 256)
        buffer.initialize(repeating: false)
        for byte in set {
            buffer[Int(byte)] = true
        }
        self.buffer = UnsafeBufferPointer(buffer)
    }

    public init(asciiTable table: AllowedASCII) {
        let buffer = UnsafeMutableBufferPointer<Bool>.allocate(capacity: 256)
        buffer.initialize(repeating: false)

        var copy = table
        let pointer = UnsafeMutableRawPointer(mutating: &copy)
            .assumingMemoryBound(to: Bool.self)
        let asciiBuffer = UnsafeBufferPointer(start: pointer, count: 128)
        _ = buffer.initialize(from: asciiBuffer)

        self.buffer = UnsafeBufferPointer(buffer)
    }

    deinit {
        buffer.deallocate()
    }
}

extension StreamReader {
    @inline(__always)
    public func read<T>(
        allowedBytes: AllowedBytes,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        let buffer = allowedBytes.buffer
        return try read(
            while: { buffer[Int($0)] },
            untilEnd: true,
            body: body)
    }

    @inline(__always)
    public func read(allowedBytes: AllowedBytes) throws -> [UInt8] {
        let buffer = allowedBytes.buffer
        return try read(while: { buffer[Int($0)] })
    }
}

public typealias AllowedASCII = (
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool,
    Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool)
