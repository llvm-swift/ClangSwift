import cclang

/// The type of an element in the abstract syntax tree.
public protocol CType: CustomStringConvertible {
    /// Converts the receiver to a `CXType` to be consumed by the libclang APIs.
    func asClang() -> CXType
}

public enum TypeLayoutError: Error {
    /// The type was invalid
    case invalid

    /// The type was a dependent type
    case dependent

    /// The type was incomplete
    case incomplete

    /// The type did not have a constant size
    case notConstantSize

    /// The field specified was not found or invalid
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

/// Represents a CType that's backed by a CXType directly
protocol ClangTypeBacked: CType {
    var clang: CXType { get }
}

extension ClangTypeBacked {
    /// Returns the underlying clang backing store
    func asClang() -> CXType {
        return clang
    }
}

extension CXType: CType {
    /// Returns self, unmodified
    public func asClang() -> CXType {
        return self
    }
}

public func ==(lhs: CType, rhs: CType) -> Bool {
    return clang_equalTypes(lhs.asClang(), rhs.asClang()) != 0
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

    /// The kind of the receiver.
    public var kind: CTypeKind {
        return CTypeKind(clang: asClang().kind)
    }
}

struct RecordType: ClangTypeBacked {
    let clang: CXType

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

    /// Gathers and returns all the fields of this record.
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
