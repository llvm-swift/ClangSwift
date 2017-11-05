#if SWIFT_PACKAGE
import cclang
#endif

public struct NameRefOptions: OptionSet {
  public typealias RawValue = CXNameRefFlags.RawValue
  public let rawValue: RawValue

  /// Creates a new NameRefOptions from a raw integer value.
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  /// Include the nested-name-specifier, e.g. Foo:: in x.Foo::y, in the range.
  public static let wantQualifier = NameRefOptions(rawValue: 
    CXNameRange_WantQualifier.rawValue)

  /// Include the explicit template arguments, e.g. <int> in x.f<int>, in the
  /// range.
  public static let wantTemplateArgs = NameRefOptions(rawValue: 
    CXNameRange_WantTemplateArgs.rawValue)

  /// If the name is non-contiguous, return the full spanning range.
  /// Non-contiguous names occur in Objective-C when a selector with two or more
  /// parameters is used, or in C++ when using an operator:
  /// ```
  /// [object doSomething:here withValue:there]; // Objective-C
  /// return some_vector[1]; // C++
  /// ```
  public static let wantSinglePiece = NameRefOptions(rawValue: 
    CXNameRange_WantSinglePiece.rawValue)
}
