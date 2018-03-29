/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol UnsafeRawBufferInitializable {
    init(_ buffer: UnsafeRawBufferPointer)
}

extension String: UnsafeRawBufferInitializable {
    public init(_ buffer: UnsafeRawBufferPointer) {
        self.init(decoding: buffer, as: UTF8.self)
    }
}

extension Array: UnsafeRawBufferInitializable where Element == UInt8 {}

extension StreamReader {
    @_inlineable
    public func peek<T>(count: Int, as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try peek(count: count) { bytes in
            return T(bytes)
        }
    }

    @_inlineable
    public func read<T>(count: Int, as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try read(count: count) { bytes in
            return T(bytes)
        }
    }

    @_inlineable
    public func read<T: UnsafeRawBufferInitializable>(
        mode: PredicateMode,
        while predicate: (UInt8) -> Bool,
        as type: T.Type) throws -> T
    {
        return try read(mode: mode, while: predicate) { bytes in
            return T(bytes)
        }
    }

    @_inlineable
    public func readUntilEnd<T>(as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try read(mode: .untilEnd, while: {_ in true}, as: type)
    }

    public func readUntilEnd() throws -> [UInt8] {
        return try readUntilEnd(as: [UInt8].self)
    }
}