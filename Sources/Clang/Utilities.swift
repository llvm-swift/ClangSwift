import cclang

internal extension Bool {
    func asClang() -> Int32 {
        return self ? 1 : 0
    }
}


extension CXString {
    func asSwiftOptional() -> String? {
        guard let cStr = clang_getCString(self) else { return nil }
        defer { clang_disposeString(self) }
        return String(cString: cStr)
    }
    func asSwift() -> String {
        return asSwiftOptional() ?? ""
    }
}

extension Collection where Iterator.Element == String, IndexDistance == Int {
    func withUnsafeCStringBuffer<Result>(_ f: (UnsafeMutableBufferPointer<UnsafePointer<Int8>?>) throws -> Result) rethrows -> Result {
        let ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: self.count)
        defer  { freelist(ptr, count: self.count) }
        for (idx, str) in enumerated() {
            str.withCString { cStr in
                ptr[idx] = strdup(cStr)
            }
        }
        let constPtr = unsafeBitCast(ptr, to: UnsafeMutablePointer<UnsafePointer<Int8>?>.self)

        return try f(UnsafeMutableBufferPointer(start: constPtr, count: self.count))
    }
}

func freelist<T>(_ ptr: UnsafeMutablePointer<UnsafeMutablePointer<T>?>, count: Int) {
    for i in 0..<count {
        free(ptr[i])
    }
    free(ptr)
}

internal class Box<T> {
    public var value: T
    init(_ value: T) { self.value = value }
}
