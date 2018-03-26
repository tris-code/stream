/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol StreamReadable {
    init(from stream: StreamReader) throws
}

extension StreamReader {
    func read<T: StreamReadable>() throws -> T {
        return try T(from: self)
    }
}

public protocol StreamReader: class {
    var buffered: Int { get }

    func cache(count: Int) throws -> Bool

    func next<T: Collection>(is elements: T) throws -> Bool
        where T.Element == UInt8

    func read<T: BinaryInteger>(_ type: T.Type) throws -> T

    func read(count: Int) throws -> [UInt8]

    func read<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T
    ) throws -> T

    func read(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool
    ) throws -> [UInt8]

    func read<T>(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool,
        body: (UnsafeRawBufferPointer) throws -> T
    ) throws -> T

    func consume(count: Int) throws

    func consume(_ byte: UInt8) throws -> Bool

    func consume(
        while predicate: (UInt8) -> Bool,
        allowingExhaustion: Bool
    ) throws
}

extension StreamReader {
    @inline(__always)
    public func read<T>(
        while predicate: (UInt8) -> Bool,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try read(
            while: predicate,
            allowingExhaustion: true,
            body: body)
    }

    @inline(__always)
    public func read<T>(
        until byte: UInt8,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try read(
            while: { $0 != byte },
            allowingExhaustion: false,
            body: body)
    }
}

extension StreamReader {
    @inline(__always)
    public func read(while predicate: (UInt8) -> Bool) throws -> [UInt8] {
        return try read(while: predicate, allowingExhaustion: true)
    }

    @inline(__always)
    public func read(until byte: UInt8) throws -> [UInt8] {
        return try read(while: { $0 != byte }, allowingExhaustion: false)
    }

    @inline(__always)
    public func consume(while predicate: (UInt8) -> Bool) throws {
        try consume(while: predicate, allowingExhaustion: true)
    }

    @inline(__always)
    public func consume(until byte: UInt8) throws {
        try consume(while: { $0 != byte }, allowingExhaustion: false)
    }

    @_inlineable
    public func consume<T>(sequence bytes: T) throws -> Bool
        where T: Collection, T.Element == UInt8
    {
        guard try cache(count: bytes.count) else {
            throw StreamError.insufficientData
        }
        guard try next(is: bytes) else {
            return false
        }
        try consume(count: bytes.count)
        return true
    }
}