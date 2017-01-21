import cclang

public enum CTypeKind {
    /// A type whose specific kind is unexposed in this interface.
    case unexposed
    case void
    case bool
    case charU
    case uChar
    case char16
    case char32
    case uShort
    case uInt
    case uLong
    case uLongLong
    case uInt128
    case charS
    case sChar
    case wChar
    case short
    case int
    case long
    case longLong
    case int128
    case float
    case double
    case longDouble
    case nullPtr
    case overload
    case dependent
    case objcId
    case objcClass
    case objcSel
    case float128
    case complex
    case pointer
    case blockPointer
    case lValueReference
    case rValueReference
    case record
    case `enum`
    case typedef
    case objcInterface
    case objcObjectPointer
    case functionNoProto
    case functionProto
    case constantArray
    case vector
    case incompleteArray
    case variableArray
    case dependentSizedArray
    case memberPointer
    case auto

    /// Represents a type that was referred to using an elaborated type keyword.
    /// e.g. `struct S`, or via a qualified name, e.g., `N::M::type`, or both.
    case elaborated

    internal init(clang: CXTypeKind) {
        self = CTypeKind.fromClangMapping[clang.rawValue]!
    }

    internal func asClang() -> CXTypeKind {
        return CTypeKind.toClangMapping[self]!
    }

    private static let fromClangMapping: [UInt32: CTypeKind] = [
        CXType_Unexposed.rawValue: .unexposed,
        CXType_Void.rawValue: .void,
        CXType_Bool.rawValue: .bool,
        CXType_Char_U.rawValue: .charU,
        CXType_UChar.rawValue: .uChar,
        CXType_Char16.rawValue: .char16,
        CXType_Char32.rawValue: .char32,
        CXType_UShort.rawValue: .uShort,
        CXType_UInt.rawValue: .uInt,
        CXType_ULong.rawValue: .uLong,
        CXType_ULongLong.rawValue: .uLongLong,
        CXType_UInt128.rawValue: .uInt128,
        CXType_Char_S.rawValue: .charS,
        CXType_SChar.rawValue: .sChar,
        CXType_WChar.rawValue: .wChar,
        CXType_Short.rawValue: .short,
        CXType_Int.rawValue: .int,
        CXType_Long.rawValue: .long,
        CXType_LongLong.rawValue: .longLong,
        CXType_Int128.rawValue: .int128,
        CXType_Float.rawValue: .float,
        CXType_Double.rawValue: .double,
        CXType_LongDouble.rawValue: .longDouble,
        CXType_NullPtr.rawValue: .nullPtr,
        CXType_Overload.rawValue: .overload,
        CXType_Dependent.rawValue: .dependent,
        CXType_ObjCId.rawValue: .objcId,
        CXType_ObjCClass.rawValue: .objcClass,
        CXType_ObjCSel.rawValue: .objcSel,
        CXType_Float128.rawValue: .float128,
        CXType_Complex.rawValue: .complex,
        CXType_Pointer.rawValue: .pointer,
        CXType_BlockPointer.rawValue: .blockPointer,
        CXType_LValueReference.rawValue: .lValueReference,
        CXType_RValueReference.rawValue: .rValueReference,
        CXType_Record.rawValue: .record,
        CXType_Enum.rawValue: .enum,
        CXType_Typedef.rawValue: .typedef,
        CXType_ObjCInterface.rawValue: .objcInterface,
        CXType_ObjCObjectPointer.rawValue: .objcObjectPointer,
        CXType_FunctionNoProto.rawValue: .functionNoProto,
        CXType_FunctionProto.rawValue: .functionProto,
        CXType_ConstantArray.rawValue: .constantArray,
        CXType_Vector.rawValue: .vector,
        CXType_IncompleteArray.rawValue: .incompleteArray,
        CXType_VariableArray.rawValue: .variableArray,
        CXType_DependentSizedArray.rawValue: .dependentSizedArray,
        CXType_MemberPointer.rawValue: .memberPointer,
        CXType_Auto.rawValue: .auto,
        CXType_Elaborated.rawValue: .elaborated
    ]
    private static let toClangMapping: [CTypeKind: CXTypeKind] = [
        .unexposed: CXType_Unexposed,
        .void: CXType_Void,
        .bool: CXType_Bool,
        .charU: CXType_Char_U,
        .uChar: CXType_UChar,
        .char16: CXType_Char16,
        .char32: CXType_Char32,
        .uShort: CXType_UShort,
        .uInt: CXType_UInt,
        .uLong: CXType_ULong,
        .uLongLong: CXType_ULongLong,
        .uInt128: CXType_UInt128,
        .charS: CXType_Char_S,
        .sChar: CXType_SChar,
        .wChar: CXType_WChar,
        .short: CXType_Short,
        .int: CXType_Int,
        .long: CXType_Long,
        .longLong: CXType_LongLong,
        .int128: CXType_Int128,
        .float: CXType_Float,
        .double: CXType_Double,
        .longDouble: CXType_LongDouble,
        .nullPtr: CXType_NullPtr,
        .overload: CXType_Overload,
        .dependent: CXType_Dependent,
        .objcId: CXType_ObjCId,
        .objcClass: CXType_ObjCClass,
        .objcSel: CXType_ObjCSel,
        .float128: CXType_Float128,
        .complex: CXType_Complex,
        .pointer: CXType_Pointer,
        .blockPointer: CXType_BlockPointer,
        .lValueReference: CXType_LValueReference,
        .rValueReference: CXType_RValueReference,
        .record: CXType_Record,
        .enum: CXType_Enum,
        .typedef: CXType_Typedef,
        .objcInterface: CXType_ObjCInterface,
        .objcObjectPointer: CXType_ObjCObjectPointer,
        .functionNoProto: CXType_FunctionNoProto,
        .functionProto: CXType_FunctionProto,
        .constantArray: CXType_ConstantArray,
        .vector: CXType_Vector,
        .incompleteArray: CXType_IncompleteArray,
        .variableArray: CXType_VariableArray,
        .dependentSizedArray: CXType_DependentSizedArray,
        .memberPointer: CXType_MemberPointer,
        .auto: CXType_Auto,
        .elaborated: CXType_Elaborated
    ]
}
