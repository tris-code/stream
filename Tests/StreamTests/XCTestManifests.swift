import XCTest

extension BufferedStreamReaderTests {
    static let __allTests = [
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
        ("testReadWhileAllowingExhaustion", testReadWhileAllowingExhaustion),
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

extension StreamTests {
    static let __allTests = [
        ("testCopyBytes", testCopyBytes),
        ("testInputStream", testInputStream),
        ("testNumeric", testNumeric),
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
        testCase(MemoryStreamTests.__allTests),
        testCase(StreamTests.__allTests),
    ]
}
#endif