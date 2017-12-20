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

class BufferedStreamWriterTests: TestCase {
    func testWriteByte() {
        let stream = OutputByteStream()
        let output = BufferedOutputStream(baseStream: stream, capacity: 5)

        assertNoThrow(try output.write(UInt8(42)))
        assertNoThrow(try output.flush())

        assertEqual(stream.bytes, [42])
    }


    static var allTests = [
        ("testWriteByte", testWriteByte)
    ]
}
