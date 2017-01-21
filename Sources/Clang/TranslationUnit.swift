import cclang

public struct TranslationUnitOptions: OptionSet {
    public typealias RawValue = UInt32
    public let rawValue: UInt32

    public init(rawValue: UInt32) { self.rawValue = rawValue }

    public static let detailedPreprocessingRecord =
        TranslationUnitOptions(rawValue: CXTranslationUnit_DetailedPreprocessingRecord.rawValue)
    public static let incomplete =
        TranslationUnitOptions(rawValue: CXTranslationUnit_Incomplete.rawValue)
    public static let precompiledPreamble =
        TranslationUnitOptions(rawValue: CXTranslationUnit_PrecompiledPreamble.rawValue)
    public static let cacheCompletionResults =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CacheCompletionResults.rawValue)
    public static let forSerialization =
        TranslationUnitOptions(rawValue: CXTranslationUnit_ForSerialization.rawValue)
    public static let cxxChainedPCH =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CXXChainedPCH.rawValue)
    public static let skipFunctionBodies =
        TranslationUnitOptions(rawValue: CXTranslationUnit_SkipFunctionBodies.rawValue)
    public static let includeBriefCommentsInCodeCompletion =
        TranslationUnitOptions(rawValue: CXTranslationUnit_IncludeBriefCommentsInCodeCompletion.rawValue)
    public static let createPreambleOnFirstParse =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CreatePreambleOnFirstParse.rawValue)
    public static let keepGoing =
        TranslationUnitOptions(rawValue: CXTranslationUnit_KeepGoing.rawValue)
}

public class TranslationUnit {
    let clang: CXTranslationUnit

    init(clang: CXTranslationUnit) {
        self.clang = clang
    }

    public init(index: Index, filename: String, commandLineArgs args: [String],
                options: TranslationUnitOptions = []) throws {
        // TODO: Handle UnsavedFiles

        self.clang = try args.withUnsafeCStringBuffer { argC in
            var unit: CXTranslationUnit?
            let err = clang_parseTranslationUnit2(index.clang, filename,
                                                  argC.baseAddress, Int32(argC.count),
                                                  nil, 0,
                                                  options.rawValue, &unit)
            if let clangErr = ClangError(clang: err) {
                throw clangErr
            }
            return unit!
        }
    }

    /// Retrieve the cursor that represents the given translation unit.
    /// The translation unit cursor can be used to start traversing the various
    /// declarations within the given translation unit.
    public var cursor: Cursor {
        return convertCursor(clang_getTranslationUnitCursor(clang))!
    }

    /// Get the original translation unit source file name.
    public var spelling: String {
        return clang_getTranslationUnitSpelling(clang).asSwift()
    }

    deinit {
        clang_disposeTranslationUnit(clang)
    }
}
