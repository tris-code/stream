/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public class BufferedStream<T: Stream>: Stream {
    public let inputStream: BufferedInputStream<T>
    public let outputStream: BufferedOutputStream<T>

    @inline(__always)
    public init(baseStream: T, capacity: Int = 4096) {
        inputStream = BufferedInputStream(
            baseStream: baseStream, capacity: capacity)
        outputStream = BufferedOutputStream(
            baseStream: baseStream, capacity: capacity)
    }

    @inline(__always)
    public func read(
        to buffer: UnsafeMutableRawPointer,
        byteCount: Int) throws -> Int {
        return try inputStream.read(to: buffer, byteCount: byteCount)
    }

    @inline(__always)
    public func write(
        from buffer: UnsafeRawPointer,
        byteCount: Int) throws -> Int
    {
        return try outputStream.write(from: buffer, byteCount: byteCount)
    }

    @inline(__always)
    public func flush() throws {
        try outputStream.flush()
    }
}

extension BufferedStream: StreamReader {
    public func cache(count: Int) throws -> Bool {
        return try inputStream.cache(count: count)
    }

    public func peek() throws -> UInt8 {
        return try inputStream.peek()
    }

    public func peek<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try inputStream.peek(count: count, body: body)
    }

    public func read<T: BinaryInteger>(_ type: T.Type) throws -> T {
        return try inputStream.read(type)
    }

    public func read<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try inputStream.read(count: count, body: body)
    }

    public func read<T>(
        while predicate: (UInt8) -> Bool,
        untilEnd: Bool,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try inputStream.read(
            while: predicate,
            untilEnd: untilEnd,
            body: body)
    }

    public func consume(count: Int) throws {
        return try inputStream.consume(count: count)
    }

    public func consume(_ byte: UInt8) throws -> Bool {
        return try inputStream.consume(byte)
    }

    public func consume(
        while predicate: (UInt8) -> Bool,
        untilEnd: Bool) throws
    {
        try inputStream.consume(
            while: predicate,
            untilEnd: untilEnd)
    }
}

extension BufferedStream: StreamWriter {
    public func write(_ byte: UInt8) throws {
        try outputStream.write(byte)
    }

    public func write<T: BinaryInteger>(_ value: T) throws {
        try outputStream.write(value)
    }

    public func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws {
        try outputStream.write(bytes, byteCount: byteCount)
    }
}
