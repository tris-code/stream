/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Test
@testable import Stream

class SubStreamReaderTests: TestCase {
    func testLimitedBy() {
        scope {
            let stream = InputByteStream([UInt8]("Hello, World!".utf8))
            let hello = try stream.withSubStream(limitedBy: 5) { stream in
                return try stream.readUntilEnd(as: String.self)
            }
            try stream.consume(count: 2)
            let world = try stream.readUntilEnd(as: String.self)

            assertEqual(hello, "Hello")
            assertEqual(world, "World!")
        }
    }

    func testSizedBy() {
        scope {
            let bytes = [0x00, 0x05] + [UInt8]("Hello, World!".utf8)
            let stream = InputByteStream(bytes)
            let hello = try stream.withSubStream(sizedBy: UInt16.self)
            { stream in
                return try stream.readUntilEnd(as: String.self)
            }
            try stream.consume(count: 2)
            let world = try stream.readUntilEnd(as: String.self)

            assertEqual(hello, "Hello")
            assertEqual(world, "World!")
        }
    }
}
