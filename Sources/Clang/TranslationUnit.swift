import cclang

struct TranslationUnitOptions: OptionSet {
    typealias RawValue = UInt32
    let rawValue: UInt32
    static let detailedPreprocessingRecord =
        TranslationUnitOptions(rawValue: CXTranslationUnit_DetailedPreprocessingRecord.rawValue)
    static let incomplete =
        TranslationUnitOptions(rawValue: CXTranslationUnit_Incomplete.rawValue)
    static let precompiledPreamble =
        TranslationUnitOptions(rawValue: CXTranslationUnit_PrecompiledPreamble.rawValue)
    static let cacheCompletionResults =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CacheCompletionResults.rawValue)
    static let forSerialization =
        TranslationUnitOptions(rawValue: CXTranslationUnit_ForSerialization.rawValue)
    static let cxxChainedPCH =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CXXChainedPCH.rawValue)
    static let skipFunctionBodies =
        TranslationUnitOptions(rawValue: CXTranslationUnit_SkipFunctionBodies.rawValue)
    static let includeBriefCommentsInCodeCompletion =
        TranslationUnitOptions(rawValue: CXTranslationUnit_IncludeBriefCommentsInCodeCompletion.rawValue)
    static let createPreambleOnFirstParse =
        TranslationUnitOptions(rawValue: CXTranslationUnit_CreatePreambleOnFirstParse.rawValue)
    static let keepGoing =
        TranslationUnitOptions(rawValue: CXTranslationUnit_KeepGoing.rawValue)
}

class TranslationUnit {
    let clang: CXTranslationUnit

    init(clang: CXTranslationUnit) {
        self.clang = clang
    }

    init(index: Index, filename: String, commandLineArgs args: [String],
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

    var cursor: Cursor {
        return convertCursor(clang_getTranslationUnitCursor(clang))!
    }

    var spelling: String {
        return clang_getTranslationUnitSpelling(clang).asSwift()
    }

    deinit {
        clang_disposeTranslationUnit(clang)
    }
}
