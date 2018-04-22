/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************
 *  This file contains code that has not yet been described                   *
 ******************************************************************************/

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
    @inlinable
    public func peek<T>(count: Int, as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try peek(count: count) { bytes in
            return T(bytes)
        }
    }

    @inlinable
    public func read<T>(count: Int, as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try read(count: count) { bytes in
            return T(bytes)
        }
    }

    @inlinable
    public func read<T: UnsafeRawBufferInitializable>(
        mode: PredicateMode,
        while predicate: (UInt8) -> Bool,
        as type: T.Type) throws -> T
    {
        return try read(mode: mode, while: predicate) { bytes in
            return T(bytes)
        }
    }

    @inlinable
    public func readUntilEnd<T>(as type: T.Type) throws -> T
        where T: UnsafeRawBufferInitializable
    {
        return try read(mode: .untilEnd, while: {_ in true}, as: type)
    }

    public func readUntilEnd() throws -> [UInt8] {
        return try readUntilEnd(as: [UInt8].self)
    }
}
