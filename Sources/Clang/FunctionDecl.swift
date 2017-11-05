#if SWIFT_PACKAGE
  import cclang
#endif

/// Describes the calling convention of a function type
public enum CallingConvention {
  case `default`
  case c
  case x86StdCall
  case x86FastCall
  case x86ThisCall
  case x86Pascal
  case aapcs
  case aapcs_vfp
  case intelOclBicc
  case x86_64Win64
  case x86_64SysV
  case x86VectorCall
  case swift
  case preserveMost
  case preserveAll
  case unexposed

  init?(clang: CXCallingConv) {
    switch clang {
    case CXCallingConv_Default: self = .default
    case CXCallingConv_C: self = .c
    case CXCallingConv_X86StdCall: self = .x86StdCall
    case CXCallingConv_X86FastCall: self = .x86FastCall
    case CXCallingConv_X86ThisCall: self = .x86ThisCall
    case CXCallingConv_X86Pascal: self = .x86Pascal
    case CXCallingConv_AAPCS: self = .aapcs
    case CXCallingConv_AAPCS_VFP: self = .aapcs_vfp
    case CXCallingConv_IntelOclBicc: self = .intelOclBicc
    case CXCallingConv_X86_64Win64: self = .x86_64Win64
    case CXCallingConv_X86_64SysV: self = .x86_64SysV
    case CXCallingConv_X86VectorCall: self = .x86VectorCall
    case CXCallingConv_Swift: self = .swift
    case CXCallingConv_PreserveMost: self = .preserveMost
    case CXCallingConv_PreserveAll: self = .preserveAll
    case CXCallingConv_Invalid: return nil
    case CXCallingConv_Unexposed: self = .unexposed
    default: fatalError("invalid CXCallingConv \(clang)")
    }
  }
}

/// Property attributes for an Objective-C @property declaration.
public struct ObjCPropertyAttributes: OptionSet {
  public typealias RawValue = CXObjCPropertyAttrKind.RawValue
  public let rawValue: RawValue

  /// Creates a new ObjCPropertyAttributes from a raw integer value.
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  /// The property has no attributes.
  public static let noattr = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_noattr.rawValue)

  /// The property was marked readonly.
  public static let readonly = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_readonly.rawValue)

  /// The property has an explicit name for the `getter`.
  public static let getter = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_getter.rawValue)

  /// The property has `assign` semantics.
  public static let assign = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_assign.rawValue)

  /// The property was explicitly marked `readwrite`.
  public static let readwrite = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_readwrite.rawValue)

  /// The property has `retain` semantics.
  public static let retain = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_retain.rawValue)

  /// The property has `copy` semantics.
  public static let copy = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_copy.rawValue)

  /// The property will be read `nonatomic`ally.
  public static let nonatomic = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_nonatomic.rawValue)

  /// The property has an explicit name for the `setter`.
  public static let setter = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_setter.rawValue)

  /// The property will be read `atomic`ally.
  public static let atomic = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_atomic.rawValue)

  /// The property is a `weak` reference.
  public static let weak = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_weak.rawValue)

  /// The property is a `strong` reference.
  public static let strong = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_strong.rawValue)

  /// The property is marked `unsafe_unretained`.
  public static let unsafe_unretained = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_unsafe_unretained.rawValue)

  /// the property is a `class` property.
  public static let `class` = ObjCPropertyAttributes(rawValue:
    CXObjCPropertyAttr_class.rawValue)
}
