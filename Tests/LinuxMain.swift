import XCTest
@testable import StreamTests

XCTMain([
    testCase(BufferedStreamReaderTests.allTests),
    testCase(BufferedStreamTests.allTests),
    testCase(MemoryStreamTests.allTests),
    testCase(StreamTests.allTests)
])
