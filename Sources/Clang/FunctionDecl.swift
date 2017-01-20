import cclang

public class FunctionDecl: ClangCursorBacked {
    let clang: CXCursor

    init(clang: CXCursor) {
        self.clang = clang
    }

    /// Retrieve the argument cursor of a function or method.
    /// The argument cursor can be determined for calls as well as for
    /// declarations of functions or methods.
    public func parameter(at index: Int) -> Cursor? {
        return convertCursor(clang_Cursor_getArgument(clang, UInt32(index)))
    }

    /// Retrieve the return type of the function.
    public var resultType: CType? {
        return convertType(clang_getCursorResultType(clang))
    }
}

public class MethodDecl: FunctionDecl {
    /// Determine the set of methods that are overridden by the given method.
    /// In both Objective-C and C++, a method (aka virtual member function, in
    /// C++) can override a virtual method in a base class. For Objective-C, a
    /// method is said to override any method in the class's base class, its 
    /// protocols, or its categories' protocols, that has the same selector and
    /// is of the same kind (class or instance). If no such method exists, the
    /// search continues to the class's superclass, its protocols, and its 
    /// categories, and so on. A method from an Objective-C implementation is 
    /// considered to override the same methods as its corresponding method in
    /// the interface.
    ///
    /// For C++, a virtual member function overrides any virtual member function
    /// with the same signature that occurs in its base classes. With multiple
    /// inheritance, a virtual member function can override several virtual
    /// member functions coming from different base classes.
    ///
    /// In all cases, this will return the immediate overridden method,
    /// rather than all of the overridden methods. For example, if a method is
    /// originally declared in a class A, then overridden in B (which in 
    /// inherits from A) and also in C (which inherited from B), then the only 
    /// overridden method returned from this function when invoked on C's method
    /// will be B's method. The client may then invoke this function again,
    /// given the previously-found overridden methods, to map out the complete
    /// method-override set.
    public var overrides: [MethodDecl] {
        var overridden: UnsafeMutablePointer<CXCursor>?
        var overrideCount = 0 as UInt32
        clang_getOverriddenCursors(clang, &overridden, &overrideCount)
        guard let overriddenPtr = overridden else { return [] }
        var overrides = [MethodDecl]()
        for i in 0..<Int(overrideCount) {
            overrides.append(MethodDecl(clang: overriddenPtr[i]))
        }
        clang_disposeOverriddenCursors(overridden)
        return overrides
    }
}

struct FieldDecl: ClangCursorBacked {
    let clang: CXCursor
}

struct StructDecl: ClangCursorBacked {
    let clang: CXCursor

    func fields() -> [Cursor] {
        guard let type = type as? RecordType else { return [] }
        return type.fields()
    }
}
