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

class SubStreamWriterTests: TestCase {
    func testSizedBy() {
        scope {
            let stream = OutputByteStream()
            try stream.withSubStream(sizedBy: UInt16.self) { stream in
                return try stream.write("Hello, World!")
            }
            assertEqual(stream.bytes[..<2], [0x00, 0x0D])
            assertEqual(stream.bytes[2...], [UInt8]("Hello, World!".utf8)[...])
        }
    }
}
