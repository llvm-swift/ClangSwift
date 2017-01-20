import cclang

public protocol Cursor {
    func asClang() -> CXCursor
}

extension CXCursor: Cursor {
    public func asClang() -> CXCursor {
        return self
    }
}

extension Cursor {
    var spelling: String {
        return clang_getCursorSpelling(asClang()).asSwift()
    }

    var usr: String {
        return clang_getCursorUSR(asClang()).asSwift()
    }

    var kind: CursorKind {
        return CursorKind(clang: asClang().kind)
    }

    var definition: Cursor {
        return convertCursor(clang_getCursorDefinition(asClang()))
    }

    var displayName: String {
        return clang_getCursorDisplayName(asClang()).asSwift()
    }

    var lexicalParent: Cursor {
        return convertCursor(clang_getCursorLexicalParent(asClang()))
    }

    var semanticParent: Cursor {
        return convertCursor(clang_getCursorSemanticParent(asClang()))
    }

    func children() -> [Cursor] {
        var children = [Cursor]()
        clang_visitChildrenWithBlock(asClang()) { child, _ in
            children.append(convertCursor(child))
            return CXChildVisit_Continue
        }
        return children
    }
}
