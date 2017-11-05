#if SWIFT_PACKAGE
import cclang
#endif

/// Represents the errors that can be thrown by libclang.
public enum ClangError: Error {
  /// Clang had an internal failure while processing the request.
  case failure

  /// Clang crashed while processing the request.
  case crashed

  /// The arguments provided to the clang invocation were invalid.
  case invalidArguments

  /// Clang failed to parse an AST from the provided source file(s).
  case astRead

  /// Constructs a ClangError from the provided CXErrorCode
  init?(clang: CXErrorCode) {
    switch clang {
    case CXError_Failure: self = .failure
    case CXError_Crashed: self = .crashed
    case CXError_ASTReadError: self = .astRead
    case CXError_InvalidArguments: self = .invalidArguments
    default: return nil
    }
  }
}
