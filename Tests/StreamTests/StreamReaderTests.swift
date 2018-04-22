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

import Test
@testable import Stream

class StreamReaderTests: TestCase {
    func testUntilEnd() {
        scope {
            let helloBytes = [UInt8]("Hello, World!".utf8)
            let stream = InputByteStream(helloBytes)
            let bytes = try stream.readUntilEnd()
            assertEqual(bytes, helloBytes)
        }
    }

    func testUntilEndAsString() {
        scope {
            let helloString = "Hello, World!"
            let helloBytes = [UInt8](helloString.utf8)
            let stream = InputByteStream(helloBytes)
            let string = try stream.readUntilEnd(as: String.self)
            assertEqual(string, helloString)
        }
    }

    func testReadLine() {
        scope {
            let lines = "Hello, World!\r\nHello, World!\r\n"
            let stream = InputByteStream([UInt8](lines.utf8))
            assertEqual(try stream.readLine(), "Hello, World!")
            assertEqual(try stream.readLine(), "Hello, World!")
            assertNil(try stream.readLine())
        }
    }
}
