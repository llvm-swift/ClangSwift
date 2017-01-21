import cclang

public protocol CType: CustomStringConvertible {
    func asClang() -> CXType
}

public enum TypeLayoutError: Error {
    case invalid
    case dependent
    case incomplete
    case notConstantSize
    case invalidFieldName

    internal init?(clang: CXTypeLayoutError) {
        switch clang {
        case CXTypeLayoutError_Dependent:
            self = .dependent
        case CXTypeLayoutError_Invalid:
            self = .invalid
        case CXTypeLayoutError_Incomplete:
            self = .incomplete
        case CXTypeLayoutError_NotConstantSize:
            self = .notConstantSize
        case CXTypeLayoutError_InvalidFieldName:
            self = .invalidFieldName
        default:
            return nil
        }
    }
}

protocol ClangTypeBacked: CType {
    var clang: CXType { get }
}

extension ClangTypeBacked {
    func asClang() -> CXType {
        return clang
    }
}

extension CXType: CType {
    public func asClang() -> CXType {
        return self
    }
}

/// Converts a raw CXType to a potentially more specialized CType.
internal func convertType(_ type: CXType) -> CType? {
    if type.kind == CXType_Invalid { return nil }
    switch (type as CType).kind {
    case .objcClass, .record:
        return RecordType(clang: type)
    default:
        return type
    }
}

extension CType {
    /// Computes the size of a type in bytes as per C++ [expr.sizeof] standard.
    /// - returns: The size of the type in bytes.
    /// - throws:
    ///     - `TypeLayoutError.invalid` if the type declaration is invalid.
    ///     - `TypeLayoutError.incomplete` if the type declaration is an
    ///       incomplete type
    ///     - `TypeLayoutError.dependent` if the type declaration is dependent
    public func sizeOf() throws -> Int {
        let val = clang_Type_getSizeOf(asClang())
        if let error = TypeLayoutError(clang: CXTypeLayoutError(rawValue: Int32(val))) {
            throw error
        }
        return Int(val)
    }

    /// Computes the offset of a named field in a record of the given type
    /// in bytes as it would be returned by __offsetof__ as per C++11[18.2p4]
    /// - returns: The offset of a field with the given name in the type.
    /// - throws:
    ///     - `TypeLayoutError.invalid` if the type declaration is not a record
    ///        field.
    ///     - `TypeLayoutError.incomplete` if the type declaration is an
    ///       incomplete type
    ///     - `TypeLayoutError.dependent` if the type declaration is dependent
    ///     - `TypeLayoutError.invalidFieldName` if the field is not found in
    ///       the receiving type.
    public func offsetOf(fieldName: String) throws -> Int {
        let val = clang_Type_getOffsetOf(asClang(), fieldName)
        if let error = TypeLayoutError(clang: CXTypeLayoutError(rawValue: Int32(val))) {
            throw error
        }
        return Int(val)
    }

    /// Computes the alignment of a type in bytes as per C++[expr.alignof]
    /// standard.
    /// - returns: The alignment of the given type, in bytes.
    /// - throws:
    ///     - `TypeLayoutError.invalid` if the type declaration is invalid.
    ///     - `TypeLayoutError.incomplete` if the type declaration is an
    ///       incomplete type
    ///     - `TypeLayoutError.dependent` if the type declaration is dependent
    ///     - `TypeLayoutError.nonConstantSize` if the type is not a constant
    ///       size
    public func alignOf() throws -> Int {
        let val = clang_Type_getAlignOf(asClang())
        if let error = TypeLayoutError(clang: CXTypeLayoutError(rawValue: Int32(val))) {
            throw error
        }
        return Int(val)
    }

    /// Pretty-print the underlying type using the rules of the language of the
    /// translation unit from which it came.
    /// - note: If the type is invalid, an empty string is returned.
    public var description: String {
        return clang_getTypeSpelling(asClang()).asSwift()
    }

    public var kind: CTypeKind {
        return CTypeKind(clang: asClang().kind)
    }
}

struct RecordType: ClangTypeBacked {
    let clang: CXType

    func fields() -> [Cursor] {
        let fields = Box([Cursor]())
        let fieldsRef = Unmanaged.passUnretained(fields)
        let opaque = fieldsRef.toOpaque()

        clang_Type_visitFields(asClang(), { (child, opaque) -> CXVisitorResult in
            let fieldsRef = Unmanaged<Box<[Cursor]>>.fromOpaque(opaque!)
            let fields = fieldsRef.takeUnretainedValue()
            if let cursor = convertCursor(child) {
                fields.value.append(cursor)
            }
            return CXVisit_Continue
        }, opaque)

        return fields.value
    }
}
