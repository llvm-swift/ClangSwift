#if !NO_SWIFTPM
import cclang
#endif

protocol EvalResult {
  var clang: CXEvalResult { get }
}

public struct IntResult: EvalResult {
  let clang: CXEvalResult
  public var value: Int {
    return Int(clang_EvalResult_getAsInt(clang))
  }
}

public struct FloatResult: EvalResult {
  let clang: CXEvalResult
  public var value: Double {
    return clang_EvalResult_getAsDouble(clang)
  }
}

public struct ObjCStrLiteralResult: EvalResult {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct StrLiteralResult: EvalResult {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct CFStrResult: EvalResult {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct OtherResult: EvalResult {
  let clang: CXEvalResult
}

public struct UnExposedResult: EvalResult {
  let clang: CXEvalResult
}

/// Converts a CXEvalResult to a EvalResult, returning `nil` if it was unsuccessful
func convertEvalResult(_ clang: CXEvalResult) -> EvalResult? {
  let kind = clang_EvalResult_getKind(clang)
  switch kind {
  case CXEval_Int: return IntResult(clang: clang)
  case CXEval_Float: return FloatResult(clang: clang)
  case CXEval_ObjCStrLiteral: return ObjCStrLiteralResult(clang: clang)
  case CXEval_StrLiteral: return StrLiteralResult(clang: clang)
  case CXEval_CFStr: return CFStrResult(clang: clang)
  case CXEval_Other: return OtherResult(clang: clang)
  case CXEval_UnExposed: return UnExposedResult(clang: clang)
  default: fatalError("invalid CXEvalResultKind \(clang)")
  }
}
