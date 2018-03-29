import XCTest

extension BufferedStreamReaderTests {
    static let __allTests = [
        ("testAdvancePositionBeforeCallback", testAdvancePositionBeforeCallback),
        ("testConsume", testConsume),
        ("testConsumeByte", testConsumeByte),
        ("testConsumeNotExpandable", testConsumeNotExpandable),
        ("testConsumeUntil", testConsumeUntil),
        ("testConsumeWhile", testConsumeWhile),
        ("testFeedLessThanReadCount", testFeedLessThanReadCount),
        ("testPeek", testPeek),
        ("testRead", testRead),
        ("testReadByte", testReadByte),
        ("testReadFixedCapacity", testReadFixedCapacity),
        ("testReadReservingCapacity", testReadReservingCapacity),
        ("testReadUntil", testReadUntil),
        ("testReadWhile", testReadWhile),
        ("testReadWhileUntilEnd", testReadWhileUntilEnd),
    ]
}

extension BufferedStreamTests {
    static let __allTests = [
        ("testBufferedInputStream", testBufferedInputStream),
        ("testBufferedInputStreamDefaultCapacity", testBufferedInputStreamDefaultCapacity),
        ("testBufferedOutputStream", testBufferedOutputStream),
        ("testBufferedOutputStreamDefaultCapacity", testBufferedOutputStreamDefaultCapacity),
        ("testBufferedStream", testBufferedStream),
        ("testBufferedStreamDefaultCapacity", testBufferedStreamDefaultCapacity),
    ]
}

extension BufferedStreamWriterTests {
    static let __allTests = [
        ("testWriteByte", testWriteByte),
    ]
}

extension ByteStreamTests {
    static let __allTests = [
        ("testAdvancePositionBeforeCallback", testAdvancePositionBeforeCallback),
        ("testCopyBytes", testCopyBytes),
        ("testInputStream", testInputStream),
        ("testNumeric", testNumeric),
        ("testOutputStream", testOutputStream),
    ]
}

extension MemoryStreamTests {
    static let __allTests = [
        ("testBuffer", testBuffer),
        ("testCapacity", testCapacity),
        ("testInitialSize", testInitialSize),
        ("testInputStream", testInputStream),
        ("testMemoryStream", testMemoryStream),
        ("testOutputStream", testOutputStream),
        ("testRead", testRead),
        ("testReadEmpty", testReadEmpty),
        ("testReallocate", testReallocate),
        ("testSeek", testSeek),
        ("testTrivial", testTrivial),
        ("testWrite", testWrite),
        ("testWriteEmpty", testWriteEmpty),
    ]
}

extension StreamReaderTests {
    static let __allTests = [
        ("testReadLine", testReadLine),
        ("testUntilEnd", testUntilEnd),
        ("testUntilEndAsString", testUntilEndAsString),
    ]
}

extension StreamTests {
    static let __allTests = [
        ("testCopyBytes", testCopyBytes),
        ("testInputStream", testInputStream),
        ("testOutputStream", testOutputStream),
        ("testStream", testStream),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BufferedStreamReaderTests.__allTests),
        testCase(BufferedStreamTests.__allTests),
        testCase(BufferedStreamWriterTests.__allTests),
        testCase(ByteStreamTests.__allTests),
        testCase(MemoryStreamTests.__allTests),
        testCase(StreamReaderTests.__allTests),
        testCase(StreamTests.__allTests),
    ]
}
#endif
