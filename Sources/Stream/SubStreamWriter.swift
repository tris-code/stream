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

public protocol SubStreamWriter: StreamWriter {
    var count: Int { get }
}

extension OutputByteStream: SubStreamWriter {
    public var count: Int {
        return bytes.count
    }
}

extension StreamWriter {
    public func withSubStream<T: FixedWidthInteger>(
        sizedBy type: T.Type,
        task: (SubStreamWriter) throws -> Void) throws
    {
        let output = OutputByteStream()
        try task(output)
        try write(T(output.bytes.count))
        try write(output.bytes)
    }
}
