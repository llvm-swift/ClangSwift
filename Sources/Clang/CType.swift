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
    public func asClang() -> CXType {
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

    /// Retrieves the cursor for the declaration of the receiver.
    public var declaration: Cursor? {
        return convertCursor(clang_getTypeDeclaration(asClang()))
    }

    /// Retrieves the Objective-C type encoding for the receiver.
    public var objcEncoding: String {
        return clang_Type_getObjCEncoding(asClang()).asSwift()
    }

    /// Retrieve the ref-qualifier kind of a function or method.
    /// The ref-qualifier is returned for C++ functions or methods. For other
    /// types or non-C++ declarations, nil is returned.
    public var cxxRefQualifier: RefQualifier? {
        return RefQualifier(clang: clang_Type_getCXXRefQualifier(asClang()))
    }

    /// The kind of the receiver.
    public var kind: CTypeKind {
        return CTypeKind(clang: asClang().kind)
    }
}

/// Represents the qualifier for C++ methods that determines how the
/// implicit `this` parameter is used in the method.
public enum RefQualifier {
    /// An l-value ref qualifier (&)
    case lvalue

    /// An r-value ref qualifier (&&)
    case rvalue

    internal init?(clang: CXRefQualifierKind) {
        switch clang {
        case CXRefQualifier_LValue: self = .lvalue
        case CXRefQualifier_RValue: self = .rvalue
        default: return nil
        }
    }
}
