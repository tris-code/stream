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

public class UnsafeRawInputStream: InputStream {
    let pointer: UnsafeRawPointer
    let count: Int

    public internal(set) var position: Int

    public var isEmpty: Bool {
        return position == count
    }

    public init(pointer: UnsafeRawPointer, count: Int) {
        self.pointer = pointer
        self.count = count
        self.position = 0
    }

    public func read(
        to buffer: UnsafeMutableRawPointer, byteCount: Int
    ) throws -> Int {
        let count = min(self.count - position, byteCount)
        let source = pointer.advanced(by: position)
        buffer.copyMemory(from: source, byteCount: count)
        position += count
        return count
    }
}

public class UnsafeRawOutputStream: OutputStream {
    let pointer: UnsafeMutableRawPointer
    let count: Int

    public private(set) var position: Int

    public init(pointer: UnsafeMutableRawPointer, count: Int) {
        self.pointer = pointer
        self.count = count
        self.position = 0
    }

    public func write(from buffer: UnsafeRawPointer, byteCount: Int) throws -> Int {
        let count = min(self.count - position, byteCount)
        guard count > 0 else {
            return 0
        }
        pointer.copyMemory(from: buffer, byteCount: count)
        position += count
        return count
    }
}
