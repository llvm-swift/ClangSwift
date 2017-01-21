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


    /// Creates a `TranslationUnit` by parsing the file at the specified path,
    /// passing optional command line arguments and options to clang.
    ///
    /// - Parameters:
    ///   - index: The index
    ///   - filename: The path you're going to parse
    ///   - args: Optional command-line arguments to pass to clang
    ///   - options: Options for how to handle the parsed file
    /// - throws: `ClangError` if the translation unit could not
    ///           be created successfully.
    public init(index: Index, filename: String,
                commandLineArgs args: [String] = [],
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

    /// Tokenizes the source code described by the given range into raw lexical
    /// tokens.
    /// - parameter range: the source range in which text should be tokenized.
    ///                    All of the tokens produced by tokenization will fall
    ///                    within this source range.
    /// - returns: All tokens that fall within the provided source range in this
    ///            translation unit.
    public func tokens(in range: SourceRange) -> [Token] {
        var tokensPtrOpt: UnsafeMutablePointer<CXToken>?
        var numTokens: UInt32 = 0
        clang_tokenize(clang, range.clang, &tokensPtrOpt, &numTokens)
        guard let tokensPtr = tokensPtrOpt else { return [] }
        var tokens = [Token]()
        for i in 0..<Int(numTokens) {
            tokens.append(Token(clang: tokensPtr[i]))
        }
        clang_disposeTokens(clang, tokensPtr, numTokens)
        return tokens
    }

    deinit {
        clang_disposeTranslationUnit(clang)
    }
}
