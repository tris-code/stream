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

class BufferedStreamWriterTests: TestCase {
    func testWriteByte() {
        let stream = OutputByteStream()
        let output = BufferedOutputStream(baseStream: stream, capacity: 5)

        assertNoThrow(try output.write(UInt8(42)))
        assertNoThrow(try output.flush())

        assertEqual(stream.bytes, [42])
    }
}
