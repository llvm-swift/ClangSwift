#if SWIFT_PACKAGE
  import cclang
#endif

import Foundation

/// Represents a C, C++, or Objective-C token.
public protocol Token {
  var clang: CXToken { get }
}

extension Token {
  
  /// Determine the spelling of the given token.
  /// The spelling of a token is the textual representation of that token,
  /// e.g., the text of an identifier or keyword.
  public func spelling(in translationUnit: TranslationUnit) -> String {
    return clang_getTokenSpelling(translationUnit.clang, clang).asSwift()
  }
  
  /// Retrieve the source location of the given token.
  /// - param translationUnit: The translation unit in which you're looking
  ///                          for this token.
  public func location(in translationUnit: TranslationUnit) -> SourceLocation {
    return SourceLocation(clang: clang_getTokenLocation(translationUnit.clang,
                                                        clang))
  }
  
  /// Retrieve a source range that covers the given token.
  /// - param translationUnit: The translation unit in which you're looking
  ///                          for this token.
  public func range(in translationUnit: TranslationUnit) -> SourceRange {
    return SourceRange(clang: clang_getTokenExtent(translationUnit.clang,
                                                   clang))
  }
}

/// A token that contains some kind of punctuation.
public struct PunctuationToken: Token {
  public let clang: CXToken
}

/// A language keyword.
public struct KeywordToken: Token {
  public let clang: CXToken
}

/// An identifier (that is not a keyword).
public struct IdentifierToken: Token {
  public let clang: CXToken
}

/// A numeric, string, or character literal.
public struct LiteralToken: Token {
  public let clang: CXToken
}

/// A comment.
public struct CommentToken: Token {
  public let clang: CXToken
}

/// Converts a CXToken to a Token, returning `nil` if it was unsuccessful
public func convertToken(_ clang: CXToken) -> Token {
  switch clang_getTokenKind(clang) {
  case CXToken_Punctuation: return PunctuationToken(clang: clang)
  case CXToken_Keyword: return KeywordToken(clang: clang)
  case CXToken_Identifier: return IdentifierToken(clang: clang)
  case CXToken_Literal: return LiteralToken(clang: clang)
  case CXToken_Comment: return CommentToken(clang: clang)
  default: fatalError("invalid CXTokenKind \(clang)")
  }
}

public struct SourceLocation {
  let clang: CXSourceLocation
  
  /// Retrieves all file, line, column, and offset attributes of the provided
  /// source location.
  internal var locations: (file: File, line: Int, column: Int, offset: Int) {
    var l = 0 as UInt32
    var c = 0 as UInt32
    var o = 0 as UInt32
    var f: CXFile?
    clang_getFileLocation(clang, &f, &l, &c, &o)
    return (file: File(clang: f!), line: Int(l), column: Int(c),
            offset: Int(o))
  }
  
  public func cursor(in translationUnit: TranslationUnit) -> Cursor? {
    return clang_getCursor(translationUnit.clang, clang)
  }
  
  /// The line to which the given source location points.
  public var line: Int {
    return locations.line
  }
  
  /// The column to which the given source location points.
  public var column: Int {
    return locations.column
  }
  
  /// The offset into the buffer to which the given source location points.
  public var offset: Int {
    return locations.offset
  }
  
  /// The file to which the given source location points.
  public var file: File {
    return locations.file
  }
}

/// Represents a half-open character range in the source code.
public struct SourceRange {
  public let clang: CXSourceRange
  
  /// Retrieve a source location representing the first character within a
  /// source range.
  public var start: SourceLocation {
    return SourceLocation(clang: clang_getRangeStart(clang))
  }
  
  /// Retrieve a source location representing the last character within a
  /// source range.
  public var end: SourceLocation {
    return SourceLocation(clang: clang_getRangeEnd(clang))
  }
}

