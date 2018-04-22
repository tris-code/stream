/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

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
