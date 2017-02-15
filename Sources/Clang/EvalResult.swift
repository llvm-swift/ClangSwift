#if !NO_SWIFTPM
import cclang
#endif

protocol EvalResultKind {
  var clang: CXEvalResult { get }
}

public struct IntResult: EvalResultKind {
  let clang: CXEvalResult
  public var value: Int {
    return Int(clang_EvalResult_getAsInt(clang))
  }
}

public struct FloatResult: EvalResultKind {
  let clang: CXEvalResult
  public var value: Double {
    return Double(clang_EvalResult_getAsDouble(clang))
  }
}

public struct ObjCStrLiteralResult: EvalResultKind {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct StrLiteralResult: EvalResultKind {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct CFStrResult: EvalResultKind {
  let clang: CXEvalResult
  public var value: String {
    return String(cString: clang_EvalResult_getAsStr(clang))
  }
}

public struct OtherResult: EvalResultKind {
  let clang: CXEvalResult
}

public struct UnExposedResult: EvalResultKind {
  let clang: CXEvalResult
}

/// Converts a CXEvalResultKind to a EvalResultKind, returning `nil` if it was unsuccessful
func convertEvalResultKind(_ clang: CXEvalResult) -> EvalResultKind? {
  switch clang_EvalResult_getKind(clang) {
  case CXEval_Int: return IntResult(clang: clang)
  case CXEval_Float: return FloatResult(clang: clang)
  case CXEval_ObjCStrLiteral: return ObjCStrLiteralResult(clang: clang)
  case CXEval_StrLiteral: return StrLiteralResult(clang: clang)
  case CXEval_CFStr: return CFStrResult(clang: clang)
  case CXEval_Other: return OtherResult(clang: clang)
  case CXEval_UnExposed: return UnExposedResult(clang: clang)
  default: fatalError("invalid CXEvalResultKindKind \(clang)")
  }
}
