/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public struct InputByteStream: InputStream {
    public let bytes: [UInt8]

    public var position = 0

    public init(_ bytes: [UInt8]) {
        self.bytes = bytes
    }

    @inline(__always)
    public mutating func read(
        to buffer: UnsafeMutableRawBufferPointer
    ) throws -> Int {
        let count = min(bytes.count - position, buffer.count)
        buffer.copyBytes(from: bytes[position..<position+count])
        position += count
        return count
    }
}

public struct OutputByteStream: OutputStream {
    public var bytes: [UInt8]

    public init(reservingCapacity capacity: Int = 1024) {
        bytes = []
        bytes.reserveCapacity(capacity)
    }

    @inline(__always)
    public mutating func write(_ bytes: UnsafeRawBufferPointer) throws -> Int {
        self.bytes.append(contentsOf: bytes)
        return bytes.count
    }
}
