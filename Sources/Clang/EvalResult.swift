#if !NO_SWIFTPM
import cclang
#endif

/// Represents the result of evaluating a CXCursor
public enum EvalResult {
    case int(Int)
    case float(Double)
    case objcStringLiteral(String)
    case stringLiteral(String)
    case cfStringLiteral(String)
    case other
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
