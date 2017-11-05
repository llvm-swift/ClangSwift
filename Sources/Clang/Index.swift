#if SWIFT_PACKAGE
  import cclang
#endif

/// An index is a context in which translation units are created.
public class Index {
  let clang: CXIndex


  /// Creates a new index in which translation units can be created.
  /// - Parameters:
  ///  - excludeDeclarationsFromPCH: When non-zero, allows enumerationof "local"
  ///                                declarations (when loading any new
  ///                                translation units). A "local" declaration
  ///                                is one that belongs in the translation unit
  ///                                itself and not in a precompiled header that
  ///                                was used by the translation unit. If zero,
  ///                                all declarations will be enumerated.
  ///                                This process of creating the 'pch', loading
  ///                                it separately, and using it (via
  ///                                -include-pch) allows clang to remove
  ///                                redundant callbacks (which gives the
  ///                                indexer the same performance benefit as the
  ///                                compiler).
  ///  - displayDiagnostics: Whether or not to display diagnostics to standard
  ///                        error while parsing any declarations in this index.
  public init(excludeDeclarationsFromPCH: Bool = true,
              displayDiagnostics: Bool = true) {
    self.clang = clang_createIndex(excludeDeclarationsFromPCH.asClang(),
                                   displayDiagnostics.asClang())
  }

  /// The general options associated with an Index.
  var globalOptions: GlobalOptions {
    get {
      return GlobalOptions(rawValue: clang_CXIndex_getGlobalOptions(clang))
    }
    set {
      clang_CXIndex_setGlobalOptions(clang, newValue.rawValue)
    }
  }

  deinit {
    clang_disposeIndex(clang)
  }
}

/// Global options used to inform the Index.
public struct GlobalOptions: OptionSet {
  public typealias RawValue = CXGlobalOptFlags.RawValue
  public let rawValue: RawValue

  /// Creates a new GlobalOptions from a raw integer value.
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  /// Used to indicate that no special CXIndex options are needed.
  public static let none = GlobalOptions(rawValue:
    CXGlobalOpt_None.rawValue)

  /// Used to indicate that threads that libclang creates for indexing purposes
  /// should use background priority.
  /// Affects #clang_indexSourceFile, #clang_indexTranslationUnit,
  /// #clang_parseTranslationUnit, #clang_saveTranslationUnit.
  public static let threadBackgroundPriorityForIndexing = GlobalOptions(rawValue:
    CXGlobalOpt_ThreadBackgroundPriorityForIndexing.rawValue)

  /// Used to indicate that threads that libclang creates for editing purposes
  /// should use background priority.
  /// Affects #clang_reparseTranslationUnit, #clang_codeCompleteAt,
  /// #clang_annotateTokens
  public static let threadBackgroundPriorityForEditing = GlobalOptions(rawValue:
    CXGlobalOpt_ThreadBackgroundPriorityForEditing.rawValue)

  /// Used to indicate that all threads that libclang creates should use
  /// background priority.
  public static let threadBackgroundPriorityForAll = GlobalOptions(rawValue:
    CXGlobalOpt_ThreadBackgroundPriorityForAll.rawValue)
}
