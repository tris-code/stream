import XCTest
@testable import StreamTests

XCTMain([
    testCase(StreamTests.allTests),
    testCase(MemoryStreamTests.allTests),
    testCase(PerformanceTests.allTests),
])
