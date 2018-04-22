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

public protocol StreamWriter: class {
    func write(_ byte: UInt8) throws
    func write<T: FixedWidthInteger>(_ value: T) throws
    func write(_ bytes: [UInt8]) throws
    func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws
    func flush() throws
}

extension StreamWriter {
    public func write(_ bytes: UnsafeRawBufferPointer) throws {
        try write(bytes.baseAddress!, byteCount: bytes.count)
    }

    public func write(_ bytes: [UInt8]) throws {
        try write(bytes, byteCount: bytes.count)
    }

    public func write(_ string: String) throws {
        try write([UInt8](string.utf8))
    }
}

public protocol StreamWritable {
    func write(to stream: StreamWriter) throws
}
