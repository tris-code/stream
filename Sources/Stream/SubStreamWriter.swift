/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public protocol SubStreamWriter: StreamWriter {
    var count: Int { get }
}

extension OutputByteStream: SubStreamWriter {
    public var count: Int {
        return bytes.count
    }
}

extension StreamWriter {
    public func withSubStream<T: FixedWidthInteger>(
        sizedBy type: T.Type,
        task: (SubStreamWriter) throws -> Void) throws
    {
        let output = OutputByteStream()
        try task(output)
        print(output.bytes.count)
        try write(T(output.bytes.count))
        try write(output.bytes)
    }
}
