/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public class UnsafeRawInputStream: InputStream {
    let pointer: UnsafeRawPointer
    let count: Int

    public private(set) var position: Int

    public init(pointer: UnsafeRawPointer, count: Int) {
        self.pointer = pointer
        self.count = count
        self.position = 0
    }

    public func read(
        to buffer: UnsafeMutableRawPointer, byteCount: Int
    ) throws -> Int {
        let count = min(self.count - position, byteCount)
        let source = pointer.advanced(by: position)
        buffer.copyMemory(from: source, byteCount: count)
        position += count
        return count
    }
}

public class UnsafeRawOutputStream: OutputStream {
    let pointer: UnsafeMutableRawPointer
    let count: Int

    public private(set) var position: Int

    public init(pointer: UnsafeMutableRawPointer, count: Int) {
        self.pointer = pointer
        self.count = count
        self.position = 0
    }

    public func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws -> Int {
        let count = min(self.count - position, byteCount)
        guard count > 0 else {
            return 0
        }
        pointer.copyMemory(from: bytes, byteCount: count)
        position += count
        return count
    }
}
