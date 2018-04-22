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

public protocol SubStreamReader: StreamReader {
    var limit: Int { get }
    var isEmpty: Bool { get }
}

extension UnsafeRawInputStream: SubStreamReader {
    public var limit: Int {
        return count
    }
}

extension StreamReader {
    public func withSubStream<H: FixedWidthInteger, T>(
        sizedBy type: H.Type,
        body: (SubStreamReader) throws -> T) throws -> T
    {
        let length = try read(type)
        return try withSubStream(limitedBy: Int(length), body: body)
    }

    public func withSubStream<T>(
        limitedBy limit: Int,
        body: (SubStreamReader) throws -> T) throws -> T
    {
        return try read(count: limit) { bytes in
            let stream = UnsafeRawInputStream(
                pointer: bytes.baseAddress!,
                count: bytes.count)
            return try body(stream)
        }
    }
}
