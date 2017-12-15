/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension OutputStream {
    public func copyBytes<T: InputStream>(
        from input: inout T,
        bufferSize: Int = 4096
    ) throws -> Int {
        var total = 0
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        while true {
            let read = try input.read(to: &buffer)
            guard read > 0 else {
                return total
            }
            total = total &+ read

            var index = 0
            while index < read {
                let written = try write(buffer[index..<read])
                guard written > 0 else {
                    throw StreamError.writtenLessThenRequired
                }
                index += written
            }
        }
    }
}
