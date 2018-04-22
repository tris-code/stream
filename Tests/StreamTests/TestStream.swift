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

import Stream

class TestStream: Stream {
    var storage = [UInt8]()

    func read(to buffer: UnsafeMutableRawPointer, byteCount: Int) throws -> Int {
        let count = min(storage.count, byteCount)
        buffer.copyMemory(from: storage, byteCount: count)
        storage.removeFirst(count)
        return count
    }

    func write(from buffer: UnsafeRawPointer, byteCount: Int) throws -> Int {
        let buffer = UnsafeRawBufferPointer(start: buffer, count: byteCount)
        storage.append(contentsOf: buffer)
        return byteCount
    }
}
