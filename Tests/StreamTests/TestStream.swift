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

class TestStream: Stream {
    var storage = [UInt8]()

    func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int {
        let count = min(storage.count, buffer.count)
        buffer.copyBytes(from: storage[..<count])
        storage = [UInt8](storage[count...])
        return count
    }

    func write(_ bytes: UnsafeRawBufferPointer) throws -> Int {
        storage.append(contentsOf: bytes)
        return bytes.count
    }
}
