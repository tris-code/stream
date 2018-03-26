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

class ByteStreamTests: TestCase {
    func testInputStream() {
        let inputStream  = InputByteStream([])
        var buffer = [UInt8]()
        assertNoThrow(try inputStream.read(to: &buffer, byteCount: 0))
    }

    func testOutputStream() {
        let outputStream  = OutputByteStream()
        let bytes = [UInt8]()
        assertNoThrow(try outputStream.write(from: bytes, byteCount: 0))
    }

    func testNumeric() {
        do {
            let outputStream  = OutputByteStream()

            try outputStream.write(Int(-1))
            try outputStream.write(Int8(-2))
            try outputStream.write(Int16(-3))
            try outputStream.write(Int32(-4))
            try outputStream.write(Int64(-5))
            try outputStream.write(UInt(1))
            try outputStream.write(UInt8(2))
            try outputStream.write(UInt16(3))
            try outputStream.write(UInt32(4))
            try outputStream.write(UInt64(5))

            let inputStream  = InputByteStream(outputStream.bytes)

            assertEqual(try inputStream.read(Int.self), -1)
            assertEqual(try inputStream.read(Int8.self), -2)
            assertEqual(try inputStream.read(Int16.self), -3)
            assertEqual(try inputStream.read(Int32.self), -4)
            assertEqual(try inputStream.read(Int64.self), -5)
            assertEqual(try inputStream.read(UInt.self), 1)
            assertEqual(try inputStream.read(UInt8.self), 2)
            assertEqual(try inputStream.read(UInt16.self), 3)
            assertEqual(try inputStream.read(UInt32.self), 4)
            assertEqual(try inputStream.read(UInt64.self), 5)
        } catch {
            fail(String(describing: error))
        }
    }

    func testCopyBytes() {
        do {
            let input = InputByteStream([0,1,2,3,4,5,6,7,8,9])
            let output = OutputByteStream()

            let copied = try output.copyBytes(from: input, bufferSize: 3)
            assertEqual(copied, 10)
            assertEqual(output.bytes, [0,1,2,3,4,5,6,7,8,9])
        } catch {
            fail(String(describing: error))
        }
    }
}
