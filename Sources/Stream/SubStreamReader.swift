/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol SubStreamReader: StreamReader {
    var limit: Int { get }
    var isEmpty: Bool { get }
}

extension UnsafeRawInputStream: SubStreamReader {
    public var limit: Int {
        return count
    }
}

extension StreamReader {
    public func withSubStream<H: FixedWidthInteger, T>(
        sizedBy type: H.Type,
        body: (SubStreamReader) throws -> T) throws -> T
    {
        let length = try read(type).bigEndian
        return try withSubStream(limitedBy: Int(length), body: body)
    }

    public func withSubStream<T>(
        limitedBy limit: Int,
        body: (SubStreamReader) throws -> T) throws -> T
    {
        return try read(count: limit) { bytes in
            let stream = UnsafeRawInputStream(
                pointer: bytes.baseAddress!,
                count: bytes.count)
            return try body(stream)
        }
    }
}
