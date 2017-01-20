import cclang

public protocol Cursor: CustomStringConvertible {
    func asClang() -> CXCursor
}

internal protocol ClangCursorBacked: Cursor {
    var clang: CXCursor { get }
}

extension ClangCursorBacked {
    public func asClang() -> CXCursor {
        return clang
    }
}

extension CXCursor: Cursor {
    public func asClang() -> CXCursor {
        return self
    }
}

extension Cursor {
    /// Retrieve a name for the entity referenced by this cursor.
    public var description: String {
        return clang_getCursorSpelling(asClang()).asSwift()
    }

    /// Retrieve a Unified Symbol Resolution (USR) for the entity referenced by
    /// the given cursor.
    /// A Unified Symbol Resolution (USR) is a string that identifies a
    /// particular entity (function, class, variable, etc.) within a program.
    /// USRs can be compared across translation units to determine, e.g., when
    /// references in one translation refer to an entity defined in another
    /// translation unit.
    var usr: String {
        return clang_getCursorUSR(asClang()).asSwift()
    }

    /// The kind of this cursor.
    var kind: CursorKind {
        return CursorKind(clang: asClang().kind)
    }

    /// For a cursor that is either a reference to or a declaration of some
    /// entity, retrieve a cursor that describes the definition of that entity.
    /// Some entities can be declared multiple times within a translation unit,
    /// but only one of those declarations can also be a definition. For
    /// example, given:
    /// ```
    /// int f(int, int);
    /// int g(int x, int y) { return f(x, y); }
    /// int f(int a, int b) { return a + b; }
    /// int f(int, int);
    /// ```
    /// there are three declarations of the function "f", but only the second
    /// one is a definition. This variable, accessed on any cursor pointing to a
    /// declaration of "f" (the first or fourth lines of the example) or a
    /// cursor referenced that uses "f" (the call to "f' inside "g"), will
    /// return a declaration cursor pointing to the definition (the second "f"
    /// declaration).
    ///
    /// If given a cursor for which there is no corresponding definition, e.g.,
    /// because there is no definition of that entity within this translation
    /// unit, returns a `NULL` cursor.
    var definition: Cursor? {
        return convertCursor(clang_getCursorDefinition(asClang()))
    }

    /// Retrieve the display name for the entity referenced by this cursor.
    /// The display name contains extra information that helps identify the
    /// cursor, such as the parameters of a function or template or the
    /// arguments of a class template specialization.
    var displayName: String {
        return clang_getCursorDisplayName(asClang()).asSwift()
    }

    /// Determine the lexical parent of the given cursor.
    /// The lexical parent of a cursor is the cursor in which the given cursor
    /// was actually written.  For many declarations, the lexical and semantic
    /// parents are equivalent. They diverge when declarations or definitions
    /// are provided out-of-line. For example:
    ///
    /// ```
    /// class C {
    ///   void f();
    /// };
    /// void C::f() { }
    /// ```
    ///
    /// In the out-of-line definition of `C::f`, the semantic parent is the class
    /// `C`, of which this function is a member. The lexical parent is the place
    /// where the declaration actually occurs in the source code; in this case,
    /// the definition occurs in the translation unit. In general, the lexical
    /// parent for a given entity can change without affecting the semantics of
    /// the program, and the lexical parent of different declarations of the
    /// same entity may be different. Changing the semantic parent of a
    /// declaration, on the other hand, can have a major impact on semantics,
    /// and redeclarations of a particular entity should all have the same
    /// semantic context.
    ///
    /// In the example above, both declarations of `C::f` have `C` as their
    /// semantic context, while the lexical context of the first `C::f` is `C`
    /// and the lexical context of the second `C::f` is the translation unit.
    /// For global declarations, the semantic parent is the translation unit.
    var lexicalParent: Cursor? {
        return convertCursor(clang_getCursorLexicalParent(asClang()))
    }

    /// Determine the semantic parent of the given cursor.
    /// The semantic parent of a cursor is the cursor that semantically contains
    /// the given cursor. For many declarations, the lexical and semantic
    /// parents are equivalent. They diverge when declarations or definitions
    /// are provided out-of-line. For example:
    ///
    /// ```
    /// class C {
    ///   void f();
    /// };
    /// void C::f() { }
    /// ```
    ///
    /// In the out-of-line definition of `C::f`, the semantic parent is the class
    /// `C`, of which this function is a member. The lexical parent is the place
    /// where the declaration actually occurs in the source code; in this case,
    /// the definition occurs in the translation unit. In general, the lexical
    /// parent for a given entity can change without affecting the semantics of
    /// the program, and the lexical parent of different declarations of the
    /// same entity may be different. Changing the semantic parent of a
    /// declaration, on the other hand, can have a major impact on semantics,
    /// and redeclarations of a particular entity should all have the same
    /// semantic context.
    ///
    /// In the example above, both declarations of `C::f` have `C` as their
    /// semantic context, while the lexical context of the first `C::f` is `C`
    /// and the lexical context of the second `C::f` is the translation unit.
    /// For global declarations, the semantic parent is the translation unit.
    var semanticParent: Cursor? {
        return convertCursor(clang_getCursorSemanticParent(asClang()))
    }

    /// For a cursor that is a reference, retrieve a cursor representing the
    /// entity that it references.
    /// Reference cursors refer to other entities in the AST. For example, an
    /// Objective-C superclass reference cursor refers to an Objective-C class.
    /// This function produces the cursor for the Objective-C class from the
    /// cursor for the superclass reference. If the input cursor is a
    /// declaration or definition, it returns that declaration or definition
    /// unchanged. Otherwise, returns the `NULL` cursor.
    var referenced: Cursor? {
        return convertCursor(clang_getCursorReferenced(asClang()))
    }

    var type: CType? {
        return convertType(clang_getCursorType(asClang()))
    }

    /// Retrieves all the children of the provided cursor.
    ///
    /// - returns: An array of `Cursors` that are children of this cursor.
    func children() -> [Cursor] {
        var children = [Cursor]()
        clang_visitChildrenWithBlock(asClang()) { child, _ in
            if let cursor = convertCursor(child) {
                children.append(cursor)
            }
            return CXChildVisit_Continue
        }
        return children
    }
}

internal func convertCursor(_ clang: CXCursor) -> Cursor? {
    if clang_Cursor_isNull(clang) != 0 { return nil }
    switch (clang as Cursor).kind {
    case .functionDecl:
        return FunctionDecl(clang: clang)
    case .structDecl:
        return StructDecl(clang: clang)
    default:
        return clang
    }
}
