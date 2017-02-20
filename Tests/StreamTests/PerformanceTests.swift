/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Stream

class PerformanceTests: TestCase {
    // 0.039 - [UInt8].append
    // 0.031 - raw memory + simple allocator
    func testWrite10x1M() {
        let stream = MemoryStream()
        let data: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        measure {
            for _ in 0..<1_000_000 {
                _ = try! stream.write(from: data, count: data.count)
            }
        }
    }

    // 7.474 - [UInt8].suffix
    // 0.022 - raw memory + start offset
    func testRead10x1M() {
        let stream = MemoryStream()
        let data: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        var buffer = [UInt8](repeating: 0, count: 10)

        for _ in 0..<1_000_000 {
            _ = try! stream.write(from: data, count: data.count)
        }

        measure {
            for _ in 0..<1_000_000 {
                _ = try! stream.read(to: &buffer, count: buffer.count)
            }
        }
    }

    static var allTests = [
        ("testWrite10x1M", testWrite10x1M),
        ("testRead10x1M", testRead10x1M),
    ]
}
