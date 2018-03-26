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

    func read(to buffer: UnsafeMutableRawPointer, byteCount: Int) throws -> Int {
        let count = min(storage.count, byteCount)
        buffer.copyMemory(from: storage, byteCount: count)
        storage.removeFirst(count)
        return count
    }

    func write(from buffer: UnsafeRawPointer, byteCount: Int) throws -> Int {
        let buffer = UnsafeRawBufferPointer(start: buffer, count: byteCount)
        storage.append(contentsOf: buffer)
        return byteCount
    }
}
