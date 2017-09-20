import XCTest
@testable import StreamTests

XCTMain([
    testCase(StreamTests.allTests),
    testCase(BufferedStreamTests.allTests),
])
