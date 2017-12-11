# Stream

Streams are an abstraction used when reading or writing files, or communicating over network sockets.<br>
The Stream protocol requires only 2 methods: `read` and `write`. Conformance to Seekable protocol is optional.<br>
[BufferedStream](https://github.com/tris-foundation/stream/blob/master/Sources/Stream/BufferedStream.swift) provides buffered access to any Stream object.<br>

## Package.swift

```swift
.package(url: "https://github.com/tris-foundation/stream.git", .branch("master"))
```

## Memo

### Stream
```swift
protocol Stream: InputStream, OutputStream {}

protocol InputStream {
    func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int
}

protocol OutputStream {
    func write(_ bytes: UnsafeRawBufferPointer) throws -> Int
}

extension InputStream {
    func read(to buffer: UnsafeMutableRawPointer, count: Int) throws -> Int
    func read(to buffer: inout ArraySlice<UInt8>) throws -> Int
    func read(to buffer: inout [UInt8]) throws -> Int
}

extension OutputStream {
    func write(_ bytes: UnsafeRawPointer, count: Int) throws -> Int
    func write(_ bytes: ArraySlice<UInt8>) throws -> Int
    func write(_ bytes: [UInt8]) throws -> Int
}
```

### Seekable
```swift
enum SeekOrigin {
    case begin, current, end
}

protocol Seekable {
    func seek(to offset: Int, from origin: SeekOrigin) throws
}
```

### BufferedStream
```swift
class BufferedInputStream<T: InputStream>: InputStream {
    let baseStream: T

    init(stream: T, capacity: Int = 4096)
    func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int
}

class BufferedOutputStream<T: OutputStream>: OutputStream {
    let baseStream: T

    init(stream: T, capacity: Int = 4096)
    func write(_ bytes: UnsafeRawBufferPointer) throws -> Int
    func flush() throws -> Int
}

class BufferedStream<T: Stream>: Stream {
    let inputStream: BufferedInputStream<T>
    let outputStream: BufferedOutputStream<T>

    init(stream: T, capacity: Int = 4096)
    func read(to buffer: UnsafeMutableRawBufferPointer) throws -> Int
    func write(_ bytes: UnsafeRawBufferPointer) throws -> Int
    func flush() throws -> Int
}
```

## Usage

```swift
func read<T: InputStream>(from stream: T) throws {
    var buffer = [UInt8](repeating: 0, count: 5)
    guard try stream.read(to: &buffer) == 5 else {
        throw ReadError()
    }
    print(buffer)
}

// Network
let socket = client.accept()
let networkStream = NetworkStream(socket: socket)
let bufferedStream = BufferedStream(stream: networkStream)
try read(from: bufferedStream)

// Memory
let memoryStream = MemoryStream()
try memoryStream.write([1,2,3,4,5])
try read(from: memoryStream)
```

## See also

[NetworkStream](https://github.com/tris-foundation/network/blob/master/Sources/Network/NetworkStream/NetworkStream.swift)<br>
[MemoryStream](https://github.com/tris-foundation/memory/blob/master/Sources/MemoryStream/MemoryStream.swift)<br>
