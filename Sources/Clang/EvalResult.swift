#if !NO_SWIFTPM
import cclang
#endif

protocol EvalResultKind {
  var clang: CXEvalResultKind { get }
}

public struct IntResult: EvalResultKind {
  let clang: CXEvalResultKind
  public var value: Int {
    return Int(clang_EvalResult_getAsInt(clang))
  }
}

public struct FloatResult: EvalResultKind {
  let clang: CXEvalResultKind
  public var value: Double {
    return Int(clang_EvalResult_getAsDouble(clang))
  }
}

public struct ObjCStrLiteralResult: EvalResultKind {
  let clang: CXEvalResultKind
  public var value: String {
    return String(cString: clang_EvalResult_getAsString(clang))
  }
}

public struct StrLiteralResult: EvalResultKind {
  let clang: CXEvalResultKind
  public var value: String {
    return String(cString: clang_EvalResult_getAsString(clang))
  }
}

public struct CFStrResult: EvalResultKind {
  let clang: CXEvalResultKind
  public var value: String {
    return String(cString: clang_EvalResult_getAsString(clang))
  }
}

public struct OtherResult: EvalResultKind {
  let clang: CXEvalResultKind
}

public struct UnExposedResult: EvalResultKind {
  let clang: CXEvalResultKind
}

/// Converts a CXEvalResultKind to a EvalResultKind, returning `nil` if it was unsuccessful
func convertEvalResultKind(_ clang: CXEvalResultKind) -> EvalResultKind? {
  if <#clang thing is null?#> { return nil }
  switch <#Get clang kind#> {
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
