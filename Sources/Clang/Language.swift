import cclang

/// The "language" a given cursor is written in.
public enum Language {
    /// The C Programming Language
    case c
    /// The Objective-C Programming Language
    case objectiveC
    /// The C++ Programming Language
    case cPlusPlus

    init?(clang: CXLanguageKind) {
        switch clang {
        case CXLanguage_C: self = .c
        case CXLanguage_ObjC: self = .objectiveC
        case CXLanguage_CPlusPlus: self = .cPlusPlus
        default: return nil
        }
    }
}
