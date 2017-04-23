#if !NO_SWIFTPM
import cclang
#endif

/// Represents the result of evaluating a CXCursor
public enum EvalResult {
    /// The cursor evaluated to an integer value.
    case int(Int)

    /// The cursor evaluated to a floating-point value.
    case float(Double)

    /// The cursor evaluated to an Objective-C String Literal.
    case objcStringLiteral(String)

    /// The cursor evaluated to a NUL-terminated C String literal (char *).
    case stringLiteral(String)

    /// The cursor evaluated to a Core Foundation CFString literal.
    case cfStringLiteral(String)

    /// The cursor evaluated to another kind of value, currently unavailable.
    case other

    /// The cursor evaluated to an explicitly unexposed value.
    case unexposed
}

/// Converts a CXEvalResult to an EvalResult, returning `nil` if it was
/// unsuccessful
func convertEvalResult(_ clang: CXEvalResult) -> EvalResult? {
  let kind = clang_EvalResult_getKind(clang)
  switch kind {
  case CXEval_Int: return .int(Int(clang_EvalResult_getAsInt(clang)))
  case CXEval_Float: return .float(clang_EvalResult_getAsDouble(clang))
  case CXEval_ObjCStrLiteral:
    let string = String(cString: clang_EvalResult_getAsStr(clang))
    return .objcStringLiteral(string)
  case CXEval_StrLiteral:
    let string = String(cString: clang_EvalResult_getAsStr(clang))
    return .stringLiteral(string)
  case CXEval_CFStr:
    let string = String(cString: clang_EvalResult_getAsStr(clang))
    return .cfStringLiteral(string)
  case CXEval_Other: return .other
  case CXEval_UnExposed: return .unexposed
  default: return nil
  }
}
