import cclang

public enum CursorKind {
    private static let fromClangMapping: [UInt32: CursorKind] = [
        CXCursor_UnexposedDecl.rawValue: .unexposedDecl,
        CXCursor_StructDecl.rawValue: .structDecl,
        CXCursor_UnionDecl.rawValue: .unionDecl,
        CXCursor_ClassDecl.rawValue: .classDecl,
        CXCursor_EnumDecl.rawValue: .enumDecl,
        CXCursor_FieldDecl.rawValue: .fieldDecl,
        CXCursor_EnumConstantDecl.rawValue: .enumConstantDecl,
        CXCursor_FunctionDecl.rawValue: .functionDecl,
        CXCursor_VarDecl.rawValue: .varDecl,
        CXCursor_ParmDecl.rawValue: .parmDecl,
        CXCursor_ObjCInterfaceDecl.rawValue: .objcInterfaceDecl,
        CXCursor_ObjCCategoryDecl.rawValue: .objcCategoryDecl,
        CXCursor_ObjCProtocolDecl.rawValue: .objcProtocolDecl,
        CXCursor_ObjCPropertyDecl.rawValue: .objcPropertyDecl,
        CXCursor_ObjCIvarDecl.rawValue: .objcIvarDecl,
        CXCursor_ObjCInstanceMethodDecl.rawValue: .objcInstanceMethodDecl,
        CXCursor_ObjCClassMethodDecl.rawValue: .objcClassMethodDecl,
        CXCursor_ObjCImplementationDecl.rawValue: .objcImplementationDecl,
        CXCursor_ObjCCategoryImplDecl.rawValue: .objcCategoryImplDecl,
        CXCursor_TypedefDecl.rawValue: .typedefDecl,
        CXCursor_CXXMethod.rawValue: .cxxMethod,
        CXCursor_Namespace.rawValue: .namespace,
        CXCursor_LinkageSpec.rawValue: .linkageSpec,
        CXCursor_Constructor.rawValue: .constructor,
        CXCursor_Destructor.rawValue: .destructor,
        CXCursor_ConversionFunction.rawValue: .conversionFunction,
        CXCursor_TemplateTypeParameter.rawValue: .templateTypeParameter,
        CXCursor_NonTypeTemplateParameter.rawValue: .nonTypeTemplateParameter,
        CXCursor_TemplateTemplateParameter.rawValue: .templateTemplateParameter,
        CXCursor_FunctionTemplate.rawValue: .functionTemplate,
        CXCursor_ClassTemplate.rawValue: .classTemplate,
        CXCursor_ClassTemplatePartialSpecialization.rawValue: .classTemplatePartialSpecialization,
        CXCursor_NamespaceAlias.rawValue: .namespaceAlias,
        CXCursor_UsingDirective.rawValue: .usingDirective,
        CXCursor_UsingDeclaration.rawValue: .usingDeclaration,
        CXCursor_TypeAliasDecl.rawValue: .typeAliasDecl,
        CXCursor_ObjCSynthesizeDecl.rawValue: .objcSynthesizeDecl,
        CXCursor_ObjCDynamicDecl.rawValue: .objcDynamicDecl,
        CXCursor_CXXAccessSpecifier.rawValue: .cxxAccessSpecifier,
        CXCursor_ObjCSuperClassRef.rawValue: .objcSuperClassRef,
        CXCursor_ObjCProtocolRef.rawValue: .objcProtocolRef,
        CXCursor_ObjCClassRef.rawValue: .objcClassRef,
        CXCursor_TypeRef.rawValue: .typeRef,
        CXCursor_CXXBaseSpecifier.rawValue: .cxxBaseSpecifier,
        CXCursor_TemplateRef.rawValue: .templateRef,
        CXCursor_NamespaceRef.rawValue: .namespaceRef,
        CXCursor_MemberRef.rawValue: .memberRef,
        CXCursor_LabelRef.rawValue: .labelRef,
        CXCursor_OverloadedDeclRef.rawValue: .overloadedDeclRef,
        CXCursor_VariableRef.rawValue: .variableRef,
        CXCursor_InvalidFile.rawValue: .invalidFile,
        CXCursor_NoDeclFound.rawValue: .noDeclFound,
        CXCursor_NotImplemented.rawValue: .notImplemented,
        CXCursor_InvalidCode.rawValue: .invalidCode,
        CXCursor_UnexposedExpr.rawValue: .unexposedExpr,
        CXCursor_DeclRefExpr.rawValue: .declRefExpr,
        CXCursor_MemberRefExpr.rawValue: .memberRefExpr,
        CXCursor_CallExpr.rawValue: .callExpr,
        CXCursor_ObjCMessageExpr.rawValue: .objcMessageExpr,
        CXCursor_BlockExpr.rawValue: .blockExpr,
        CXCursor_IntegerLiteral.rawValue: .integerLiteral,
        CXCursor_FloatingLiteral.rawValue: .floatingLiteral,
        CXCursor_ImaginaryLiteral.rawValue: .imaginaryLiteral,
        CXCursor_StringLiteral.rawValue: .stringLiteral,
        CXCursor_CharacterLiteral.rawValue: .characterLiteral,
        CXCursor_ParenExpr.rawValue: .parenExpr,
        CXCursor_UnaryOperator.rawValue: .unaryOperator,
        CXCursor_ArraySubscriptExpr.rawValue: .arraySubscriptExpr,
        CXCursor_BinaryOperator.rawValue: .binaryOperator,
        CXCursor_CompoundAssignOperator.rawValue: .compoundAssignOperator,
        CXCursor_ConditionalOperator.rawValue: .conditionalOperator,
        CXCursor_CStyleCastExpr.rawValue: .cStyleCastExpr,
        CXCursor_CompoundLiteralExpr.rawValue: .compoundLiteralExpr,
        CXCursor_InitListExpr.rawValue: .initListExpr,
        CXCursor_AddrLabelExpr.rawValue: .addrLabelExpr,
        CXCursor_StmtExpr.rawValue: .stmtExpr,
        CXCursor_GenericSelectionExpr.rawValue: .genericSelectionExpr,
        CXCursor_GNUNullExpr.rawValue: .gnuNullExpr,
        CXCursor_CXXStaticCastExpr.rawValue: .cxxStaticCastExpr,
        CXCursor_CXXDynamicCastExpr.rawValue: .cxxDynamicCastExpr,
        CXCursor_CXXReinterpretCastExpr.rawValue: .cxxReinterpretCastExpr,
        CXCursor_CXXConstCastExpr.rawValue: .cxxConstCastExpr,
        CXCursor_CXXFunctionalCastExpr.rawValue: .cxxFunctionalCastExpr,
        CXCursor_CXXTypeidExpr.rawValue: .cxxTypeidExpr,
        CXCursor_CXXBoolLiteralExpr.rawValue: .cxxBoolLiteralExpr,
        CXCursor_CXXNullPtrLiteralExpr.rawValue: .cxxNullPtrLiteralExpr,
        CXCursor_CXXThisExpr.rawValue: .cxxThisExpr,
        CXCursor_CXXThrowExpr.rawValue: .cxxThrowExpr,
        CXCursor_CXXNewExpr.rawValue: .cxxNewExpr,
        CXCursor_CXXDeleteExpr.rawValue: .cxxDeleteExpr,
        CXCursor_UnaryExpr.rawValue: .unaryExpr,
        CXCursor_ObjCStringLiteral.rawValue: .objcStringLiteral,
        CXCursor_ObjCEncodeExpr.rawValue: .objcEncodeExpr,
        CXCursor_ObjCSelectorExpr.rawValue: .objcSelectorExpr,
        CXCursor_ObjCProtocolExpr.rawValue: .objcProtocolExpr,
        CXCursor_ObjCBridgedCastExpr.rawValue: .objcBridgedCastExpr,
        CXCursor_PackExpansionExpr.rawValue: .packExpansionExpr,
        CXCursor_SizeOfPackExpr.rawValue: .sizeOfPackExpr,
        CXCursor_LambdaExpr.rawValue: .lambdaExpr,
        CXCursor_ObjCBoolLiteralExpr.rawValue: .objcBoolLiteralExpr,
        CXCursor_ObjCSelfExpr.rawValue: .objcSelfExpr,
        CXCursor_OMPArraySectionExpr.rawValue: .ompArraySectionExpr,
        CXCursor_ObjCAvailabilityCheckExpr.rawValue: .objcAvailabilityCheckExpr,
        CXCursor_UnexposedStmt.rawValue: .unexposedStmt,
        CXCursor_LabelStmt.rawValue: .labelStmt,
        CXCursor_CompoundStmt.rawValue: .compoundStmt,
        CXCursor_CaseStmt.rawValue: .caseStmt,
        CXCursor_DefaultStmt.rawValue: .defaultStmt,
        CXCursor_IfStmt.rawValue: .ifStmt,
        CXCursor_SwitchStmt.rawValue: .switchStmt,
        CXCursor_WhileStmt.rawValue: .whileStmt,
        CXCursor_DoStmt.rawValue: .doStmt,
        CXCursor_ForStmt.rawValue: .forStmt,
        CXCursor_GotoStmt.rawValue: .gotoStmt,
        CXCursor_IndirectGotoStmt.rawValue: .indirectGotoStmt,
        CXCursor_ContinueStmt.rawValue: .continueStmt,
        CXCursor_BreakStmt.rawValue: .breakStmt,
        CXCursor_ReturnStmt.rawValue: .returnStmt,
        CXCursor_AsmStmt.rawValue: .asmStmt,
        CXCursor_ObjCAtTryStmt.rawValue: .objcAtTryStmt,
        CXCursor_ObjCAtCatchStmt.rawValue: .objcAtCatchStmt,
        CXCursor_ObjCAtFinallyStmt.rawValue: .objcAtFinallyStmt,
        CXCursor_ObjCAtThrowStmt.rawValue: .objcAtThrowStmt,
        CXCursor_ObjCAtSynchronizedStmt.rawValue: .objcAtSynchronizedStmt,
        CXCursor_ObjCAutoreleasePoolStmt.rawValue: .objcAutoreleasePoolStmt,
        CXCursor_ObjCForCollectionStmt.rawValue: .objcForCollectionStmt,
        CXCursor_CXXCatchStmt.rawValue: .cxxCatchStmt,
        CXCursor_CXXTryStmt.rawValue: .cxxTryStmt,
        CXCursor_CXXForRangeStmt.rawValue: .cxxForRangeStmt,
        CXCursor_SEHTryStmt.rawValue: .sehTryStmt,
        CXCursor_SEHExceptStmt.rawValue: .sehExceptStmt,
        CXCursor_SEHFinallyStmt.rawValue: .sehFinallyStmt,
        CXCursor_MSAsmStmt.rawValue: .msAsmStmt,
        CXCursor_NullStmt.rawValue: .nullStmt,
        CXCursor_DeclStmt.rawValue: .declStmt,
        CXCursor_OMPParallelDirective.rawValue: .ompParallelDirective,
        CXCursor_OMPSimdDirective.rawValue: .ompSimdDirective,
        CXCursor_OMPForDirective.rawValue: .ompForDirective,
        CXCursor_OMPSectionsDirective.rawValue: .ompSectionsDirective,
        CXCursor_OMPSectionDirective.rawValue: .ompSectionDirective,
        CXCursor_OMPSingleDirective.rawValue: .ompSingleDirective,
        CXCursor_OMPParallelForDirective.rawValue: .ompParallelForDirective,
        CXCursor_OMPParallelSectionsDirective.rawValue: .ompParallelSectionsDirective,
        CXCursor_OMPTaskDirective.rawValue: .ompTaskDirective,
        CXCursor_OMPMasterDirective.rawValue: .ompMasterDirective,
        CXCursor_OMPCriticalDirective.rawValue: .ompCriticalDirective,
        CXCursor_OMPTaskyieldDirective.rawValue: .ompTaskyieldDirective,
        CXCursor_OMPBarrierDirective.rawValue: .ompBarrierDirective,
        CXCursor_OMPTaskwaitDirective.rawValue: .ompTaskwaitDirective,
        CXCursor_OMPFlushDirective.rawValue: .ompFlushDirective,
        CXCursor_SEHLeaveStmt.rawValue: .sehLeaveStmt,
        CXCursor_OMPOrderedDirective.rawValue: .ompOrderedDirective,
        CXCursor_OMPAtomicDirective.rawValue: .ompAtomicDirective,
        CXCursor_OMPForSimdDirective.rawValue: .ompForSimdDirective,
        CXCursor_OMPParallelForSimdDirective.rawValue: .ompParallelForSimdDirective,
        CXCursor_OMPTargetDirective.rawValue: .ompTargetDirective,
        CXCursor_OMPTeamsDirective.rawValue: .ompTeamsDirective,
        CXCursor_OMPTaskgroupDirective.rawValue: .ompTaskgroupDirective,
        CXCursor_OMPCancellationPointDirective.rawValue: .ompCancellationPointDirective,
        CXCursor_OMPCancelDirective.rawValue: .ompCancelDirective,
        CXCursor_OMPTargetDataDirective.rawValue: .ompTargetDataDirective,
        CXCursor_OMPTaskLoopDirective.rawValue: .ompTaskLoopDirective,
        CXCursor_OMPTaskLoopSimdDirective.rawValue: .ompTaskLoopSimdDirective,
        CXCursor_OMPDistributeDirective.rawValue: .ompDistributeDirective,
        CXCursor_OMPTargetEnterDataDirective.rawValue: .ompTargetEnterDataDirective,
        CXCursor_OMPTargetExitDataDirective.rawValue: .ompTargetExitDataDirective,
        CXCursor_OMPTargetParallelDirective.rawValue: .ompTargetParallelDirective,
        CXCursor_OMPTargetParallelForDirective.rawValue: .ompTargetParallelForDirective,
        CXCursor_OMPTargetUpdateDirective.rawValue: .ompTargetUpdateDirective,
        CXCursor_OMPDistributeParallelForDirective.rawValue: .ompDistributeParallelForDirective,
        CXCursor_OMPDistributeParallelForSimdDirective.rawValue: .ompDistributeParallelForSimdDirective,
        CXCursor_OMPDistributeSimdDirective.rawValue: .ompDistributeSimdDirective,
        CXCursor_OMPTargetParallelForSimdDirective.rawValue: .ompTargetParallelForSimdDirective,
        CXCursor_TranslationUnit.rawValue: .translationUnit,
        CXCursor_UnexposedAttr.rawValue: .unexposedAttr,
        CXCursor_IBActionAttr.rawValue: .ibActionAttr,
        CXCursor_IBOutletAttr.rawValue: .ibOutletAttr,
        CXCursor_IBOutletCollectionAttr.rawValue: .ibOutletCollectionAttr,
        CXCursor_CXXFinalAttr.rawValue: .cxxFinalAttr,
        CXCursor_CXXOverrideAttr.rawValue: .cxxOverrideAttr,
        CXCursor_AnnotateAttr.rawValue: .annotateAttr,
        CXCursor_AsmLabelAttr.rawValue: .asmLabelAttr,
        CXCursor_PackedAttr.rawValue: .packedAttr,
        CXCursor_PureAttr.rawValue: .pureAttr,
        CXCursor_ConstAttr.rawValue: .constAttr,
        CXCursor_NoDuplicateAttr.rawValue: .noDuplicateAttr,
        CXCursor_CUDAConstantAttr.rawValue: .cudaConstantAttr,
        CXCursor_CUDADeviceAttr.rawValue: .cudaDeviceAttr,
        CXCursor_CUDAGlobalAttr.rawValue: .cudaGlobalAttr,
        CXCursor_CUDAHostAttr.rawValue: .cudaHostAttr,
        CXCursor_CUDASharedAttr.rawValue: .cudaSharedAttr,
        CXCursor_VisibilityAttr.rawValue: .visibilityAttr,
        CXCursor_DLLExport.rawValue: .dllExport,
        CXCursor_DLLImport.rawValue: .dllImport,
        CXCursor_PreprocessingDirective.rawValue: .preprocessingDirective,
        CXCursor_MacroDefinition.rawValue: .macroDefinition,
        CXCursor_MacroExpansion.rawValue: .macroExpansion,
        CXCursor_InclusionDirective.rawValue: .inclusionDirective,
        CXCursor_ModuleImportDecl.rawValue: .moduleImportDecl,
        CXCursor_TypeAliasTemplateDecl.rawValue: .typeAliasTemplateDecl,
        CXCursor_StaticAssert.rawValue: .staticAssert,
        CXCursor_OverloadCandidate.rawValue: .overloadCandidate
    ]
    
    private static let toClangMapping: [CursorKind: CXCursorKind] = [
        .unexposedDecl: CXCursor_UnexposedDecl,
        .structDecl: CXCursor_StructDecl,
        .unionDecl: CXCursor_UnionDecl,
        .classDecl: CXCursor_ClassDecl,
        .enumDecl: CXCursor_EnumDecl,
        .fieldDecl: CXCursor_FieldDecl,
        .enumConstantDecl: CXCursor_EnumConstantDecl,
        .functionDecl: CXCursor_FunctionDecl,
        .varDecl: CXCursor_VarDecl,
        .parmDecl: CXCursor_ParmDecl,
        .objcInterfaceDecl: CXCursor_ObjCInterfaceDecl,
        .objcCategoryDecl: CXCursor_ObjCCategoryDecl,
        .objcProtocolDecl: CXCursor_ObjCProtocolDecl,
        .objcPropertyDecl: CXCursor_ObjCPropertyDecl,
        .objcIvarDecl: CXCursor_ObjCIvarDecl,
        .objcInstanceMethodDecl: CXCursor_ObjCInstanceMethodDecl,
        .objcClassMethodDecl: CXCursor_ObjCClassMethodDecl,
        .objcImplementationDecl: CXCursor_ObjCImplementationDecl,
        .objcCategoryImplDecl: CXCursor_ObjCCategoryImplDecl,
        .typedefDecl: CXCursor_TypedefDecl,
        .cxxMethod: CXCursor_CXXMethod,
        .namespace: CXCursor_Namespace,
        .linkageSpec: CXCursor_LinkageSpec,
        .constructor: CXCursor_Constructor,
        .destructor: CXCursor_Destructor,
        .conversionFunction: CXCursor_ConversionFunction,
        .templateTypeParameter: CXCursor_TemplateTypeParameter,
        .nonTypeTemplateParameter: CXCursor_NonTypeTemplateParameter,
        .templateTemplateParameter: CXCursor_TemplateTemplateParameter,
        .functionTemplate: CXCursor_FunctionTemplate,
        .classTemplate: CXCursor_ClassTemplate,
        .classTemplatePartialSpecialization: CXCursor_ClassTemplatePartialSpecialization,
        .namespaceAlias: CXCursor_NamespaceAlias,
        .usingDirective: CXCursor_UsingDirective,
        .usingDeclaration: CXCursor_UsingDeclaration,
        .typeAliasDecl: CXCursor_TypeAliasDecl,
        .objcSynthesizeDecl: CXCursor_ObjCSynthesizeDecl,
        .objcDynamicDecl: CXCursor_ObjCDynamicDecl,
        .cxxAccessSpecifier: CXCursor_CXXAccessSpecifier,
        .objcSuperClassRef: CXCursor_ObjCSuperClassRef,
        .objcProtocolRef: CXCursor_ObjCProtocolRef,
        .objcClassRef: CXCursor_ObjCClassRef,
        .typeRef: CXCursor_TypeRef,
        .cxxBaseSpecifier: CXCursor_CXXBaseSpecifier,
        .templateRef: CXCursor_TemplateRef,
        .namespaceRef: CXCursor_NamespaceRef,
        .memberRef: CXCursor_MemberRef,
        .labelRef: CXCursor_LabelRef,
        .overloadedDeclRef: CXCursor_OverloadedDeclRef,
        .variableRef: CXCursor_VariableRef,
        .invalidFile: CXCursor_InvalidFile,
        .noDeclFound: CXCursor_NoDeclFound,
        .notImplemented: CXCursor_NotImplemented,
        .invalidCode: CXCursor_InvalidCode,
        .unexposedExpr: CXCursor_UnexposedExpr,
        .declRefExpr: CXCursor_DeclRefExpr,
        .memberRefExpr: CXCursor_MemberRefExpr,
        .callExpr: CXCursor_CallExpr,
        .objcMessageExpr: CXCursor_ObjCMessageExpr,
        .blockExpr: CXCursor_BlockExpr,
        .integerLiteral: CXCursor_IntegerLiteral,
        .floatingLiteral: CXCursor_FloatingLiteral,
        .imaginaryLiteral: CXCursor_ImaginaryLiteral,
        .stringLiteral: CXCursor_StringLiteral,
        .characterLiteral: CXCursor_CharacterLiteral,
        .parenExpr: CXCursor_ParenExpr,
        .unaryOperator: CXCursor_UnaryOperator,
        .arraySubscriptExpr: CXCursor_ArraySubscriptExpr,
        .binaryOperator: CXCursor_BinaryOperator,
        .compoundAssignOperator: CXCursor_CompoundAssignOperator,
        .conditionalOperator: CXCursor_ConditionalOperator,
        .cStyleCastExpr: CXCursor_CStyleCastExpr,
        .compoundLiteralExpr: CXCursor_CompoundLiteralExpr,
        .initListExpr: CXCursor_InitListExpr,
        .addrLabelExpr: CXCursor_AddrLabelExpr,
        .stmtExpr: CXCursor_StmtExpr,
        .genericSelectionExpr: CXCursor_GenericSelectionExpr,
        .gnuNullExpr: CXCursor_GNUNullExpr,
        .cxxStaticCastExpr: CXCursor_CXXStaticCastExpr,
        .cxxDynamicCastExpr: CXCursor_CXXDynamicCastExpr,
        .cxxReinterpretCastExpr: CXCursor_CXXReinterpretCastExpr,
        .cxxConstCastExpr: CXCursor_CXXConstCastExpr,
        .cxxFunctionalCastExpr: CXCursor_CXXFunctionalCastExpr,
        .cxxTypeidExpr: CXCursor_CXXTypeidExpr,
        .cxxBoolLiteralExpr: CXCursor_CXXBoolLiteralExpr,
        .cxxNullPtrLiteralExpr: CXCursor_CXXNullPtrLiteralExpr,
        .cxxThisExpr: CXCursor_CXXThisExpr,
        .cxxThrowExpr: CXCursor_CXXThrowExpr,
        .cxxNewExpr: CXCursor_CXXNewExpr,
        .cxxDeleteExpr: CXCursor_CXXDeleteExpr,
        .unaryExpr: CXCursor_UnaryExpr,
        .objcStringLiteral: CXCursor_ObjCStringLiteral,
        .objcEncodeExpr: CXCursor_ObjCEncodeExpr,
        .objcSelectorExpr: CXCursor_ObjCSelectorExpr,
        .objcProtocolExpr: CXCursor_ObjCProtocolExpr,
        .objcBridgedCastExpr: CXCursor_ObjCBridgedCastExpr,
        .packExpansionExpr: CXCursor_PackExpansionExpr,
        .sizeOfPackExpr: CXCursor_SizeOfPackExpr,
        .lambdaExpr: CXCursor_LambdaExpr,
        .objcBoolLiteralExpr: CXCursor_ObjCBoolLiteralExpr,
        .objcSelfExpr: CXCursor_ObjCSelfExpr,
        .ompArraySectionExpr: CXCursor_OMPArraySectionExpr,
        .objcAvailabilityCheckExpr: CXCursor_ObjCAvailabilityCheckExpr,
        .unexposedStmt: CXCursor_UnexposedStmt,
        .labelStmt: CXCursor_LabelStmt,
        .compoundStmt: CXCursor_CompoundStmt,
        .caseStmt: CXCursor_CaseStmt,
        .defaultStmt: CXCursor_DefaultStmt,
        .ifStmt: CXCursor_IfStmt,
        .switchStmt: CXCursor_SwitchStmt,
        .whileStmt: CXCursor_WhileStmt,
        .doStmt: CXCursor_DoStmt,
        .forStmt: CXCursor_ForStmt,
        .gotoStmt: CXCursor_GotoStmt,
        .indirectGotoStmt: CXCursor_IndirectGotoStmt,
        .continueStmt: CXCursor_ContinueStmt,
        .breakStmt: CXCursor_BreakStmt,
        .returnStmt: CXCursor_ReturnStmt,
        .asmStmt: CXCursor_AsmStmt,
        .objcAtTryStmt: CXCursor_ObjCAtTryStmt,
        .objcAtCatchStmt: CXCursor_ObjCAtCatchStmt,
        .objcAtFinallyStmt: CXCursor_ObjCAtFinallyStmt,
        .objcAtThrowStmt: CXCursor_ObjCAtThrowStmt,
        .objcAtSynchronizedStmt: CXCursor_ObjCAtSynchronizedStmt,
        .objcAutoreleasePoolStmt: CXCursor_ObjCAutoreleasePoolStmt,
        .objcForCollectionStmt: CXCursor_ObjCForCollectionStmt,
        .cxxCatchStmt: CXCursor_CXXCatchStmt,
        .cxxTryStmt: CXCursor_CXXTryStmt,
        .cxxForRangeStmt: CXCursor_CXXForRangeStmt,
        .sehTryStmt: CXCursor_SEHTryStmt,
        .sehExceptStmt: CXCursor_SEHExceptStmt,
        .sehFinallyStmt: CXCursor_SEHFinallyStmt,
        .msAsmStmt: CXCursor_MSAsmStmt,
        .nullStmt: CXCursor_NullStmt,
        .declStmt: CXCursor_DeclStmt,
        .ompParallelDirective: CXCursor_OMPParallelDirective,
        .ompSimdDirective: CXCursor_OMPSimdDirective,
        .ompForDirective: CXCursor_OMPForDirective,
        .ompSectionsDirective: CXCursor_OMPSectionsDirective,
        .ompSectionDirective: CXCursor_OMPSectionDirective,
        .ompSingleDirective: CXCursor_OMPSingleDirective,
        .ompParallelForDirective: CXCursor_OMPParallelForDirective,
        .ompParallelSectionsDirective: CXCursor_OMPParallelSectionsDirective,
        .ompTaskDirective: CXCursor_OMPTaskDirective,
        .ompMasterDirective: CXCursor_OMPMasterDirective,
        .ompCriticalDirective: CXCursor_OMPCriticalDirective,
        .ompTaskyieldDirective: CXCursor_OMPTaskyieldDirective,
        .ompBarrierDirective: CXCursor_OMPBarrierDirective,
        .ompTaskwaitDirective: CXCursor_OMPTaskwaitDirective,
        .ompFlushDirective: CXCursor_OMPFlushDirective,
        .sehLeaveStmt: CXCursor_SEHLeaveStmt,
        .ompOrderedDirective: CXCursor_OMPOrderedDirective,
        .ompAtomicDirective: CXCursor_OMPAtomicDirective,
        .ompForSimdDirective: CXCursor_OMPForSimdDirective,
        .ompParallelForSimdDirective: CXCursor_OMPParallelForSimdDirective,
        .ompTargetDirective: CXCursor_OMPTargetDirective,
        .ompTeamsDirective: CXCursor_OMPTeamsDirective,
        .ompTaskgroupDirective: CXCursor_OMPTaskgroupDirective,
        .ompCancellationPointDirective: CXCursor_OMPCancellationPointDirective,
        .ompCancelDirective: CXCursor_OMPCancelDirective,
        .ompTargetDataDirective: CXCursor_OMPTargetDataDirective,
        .ompTaskLoopDirective: CXCursor_OMPTaskLoopDirective,
        .ompTaskLoopSimdDirective: CXCursor_OMPTaskLoopSimdDirective,
        .ompDistributeDirective: CXCursor_OMPDistributeDirective,
        .ompTargetEnterDataDirective: CXCursor_OMPTargetEnterDataDirective,
        .ompTargetExitDataDirective: CXCursor_OMPTargetExitDataDirective,
        .ompTargetParallelDirective: CXCursor_OMPTargetParallelDirective,
        .ompTargetParallelForDirective: CXCursor_OMPTargetParallelForDirective,
        .ompTargetUpdateDirective: CXCursor_OMPTargetUpdateDirective,
        .ompDistributeParallelForDirective: CXCursor_OMPDistributeParallelForDirective,
        .ompDistributeParallelForSimdDirective: CXCursor_OMPDistributeParallelForSimdDirective,
        .ompDistributeSimdDirective: CXCursor_OMPDistributeSimdDirective,
        .ompTargetParallelForSimdDirective: CXCursor_OMPTargetParallelForSimdDirective,
        .translationUnit: CXCursor_TranslationUnit,
        .unexposedAttr: CXCursor_UnexposedAttr,
        .ibActionAttr: CXCursor_IBActionAttr,
        .ibOutletAttr: CXCursor_IBOutletAttr,
        .ibOutletCollectionAttr: CXCursor_IBOutletCollectionAttr,
        .cxxFinalAttr: CXCursor_CXXFinalAttr,
        .cxxOverrideAttr: CXCursor_CXXOverrideAttr,
        .annotateAttr: CXCursor_AnnotateAttr,
        .asmLabelAttr: CXCursor_AsmLabelAttr,
        .packedAttr: CXCursor_PackedAttr,
        .pureAttr: CXCursor_PureAttr,
        .constAttr: CXCursor_ConstAttr,
        .noDuplicateAttr: CXCursor_NoDuplicateAttr,
        .cudaConstantAttr: CXCursor_CUDAConstantAttr,
        .cudaDeviceAttr: CXCursor_CUDADeviceAttr,
        .cudaGlobalAttr: CXCursor_CUDAGlobalAttr,
        .cudaHostAttr: CXCursor_CUDAHostAttr,
        .cudaSharedAttr: CXCursor_CUDASharedAttr,
        .visibilityAttr: CXCursor_VisibilityAttr,
        .dllExport: CXCursor_DLLExport,
        .dllImport: CXCursor_DLLImport,
        .preprocessingDirective: CXCursor_PreprocessingDirective,
        .macroDefinition: CXCursor_MacroDefinition,
        .macroExpansion: CXCursor_MacroExpansion,
        .inclusionDirective: CXCursor_InclusionDirective,
        .moduleImportDecl: CXCursor_ModuleImportDecl,
        .typeAliasTemplateDecl: CXCursor_TypeAliasTemplateDecl,
        .staticAssert: CXCursor_StaticAssert,
        .overloadCandidate: CXCursor_OverloadCandidate
    ]

    /// 
    init(clang: CXCursorKind) {
        self = CursorKind.fromClangMapping[clang.rawValue]!
    }

    func asClang() -> CXCursorKind {
        return CursorKind.toClangMapping[self]!
    }

    /// A C or C++ struct.
    case structDecl

    ///A C or C++ union.
    case unionDecl

    /// A C++ class.
    case classDecl

    /// An enumeration.
    case enumDecl

    /// A field (in C) or non-static data member (in C++) in a
    /// struct, union, or C++ class.
    case fieldDecl

    /// An enumerator constant.
    case enumConstantDecl

    /// A function.
    case functionDecl

    /// A variable.
    case varDecl

    ///A function or method parameter.
    case parmDecl

    /// An Objective-C `@interface`.
    case objcInterfaceDecl

    ///An Objective-C `@interface` for a category.
    case objcCategoryDecl

    /// An Objective-C `@protocol` declaration.
    case objcProtocolDecl

    /// An Objective-C `@property` declaration.
    case objcPropertyDecl

    /// An Objective-C instance variable.
    case objcIvarDecl

    /// An Objective-C instance method.
    case objcInstanceMethodDecl

    /// An Objective-C class method.
    case objcClassMethodDecl

    /// An Objective-C `@implementation`.
    case objcImplementationDecl

    /// An Objective-C `@implementation` for a category.
    case objcCategoryImplDecl

    /// A typedef.
    case typedefDecl

    /// A C++ class method.
    case cxxMethod

    /// A C++ namespace.
    case namespace

    /// A linkage specification, e.g. 'extern "C"'
    case linkageSpec

    /// A C++ constructor.
    case constructor

    /// A C++ destructor.
    case destructor

    /// A C++ conversion function.
    case conversionFunction

    /// A C++ template type parameter.
    case templateTypeParameter

    /// A C++ non-type template parameter.
    case nonTypeTemplateParameter

    /// A C++ template template parameter.
    case templateTemplateParameter

    /// A C++ function template.
    case functionTemplate

    /// A C++ class template.
    case classTemplate

    /// A C++ class template partial specialization.
    case classTemplatePartialSpecialization

    /// A C++ namespace alias declaration.
    case namespaceAlias

    /// A C++ using directive.
    case usingDirective

    /// A C++ using declaration.
    case usingDeclaration

    /// A C++ alias declaration
    case typeAliasDecl

    /// An Objective-C \@synthesize definition.
    case objcSynthesizeDecl

    /// An Objective-C \@dynamic definition.
    case objcDynamicDecl

    /// An access specifier.
    case cxxAccessSpecifier

    // MARK: Declarations
    case unexposedDecl

    /// MARK: References
    case firstRef

    /// MARK: Decl references
    case objcSuperClassRef
    case objcProtocolRef
    case objcClassRef

    ///
    /// A reference to a type declaration.
    /// A type reference occurs anywhere where a type is named but not
    /// declared. For example, given:
    //
    /// ```
    /// typedef unsigned size_type;
    /// size_type size;
    /// ```
    /// The typedef is a declaration of size_type (TypedefDecl)
    /// while the type of the variable "size" is referenced. The cursor referenced
    /// by the type of size is the typedef for size_type.
    case typeRef
    case cxxBaseSpecifier

    /// A reference to a class template, function template
    /// template template parameter, or class template partial
    /// specialization.
    case templateRef

    /// A reference to a namespace or namespace alias.
    case namespaceRef

    /// A reference to a member of a struct, union, or class that
    /// occurs in  some non-expression context, e.g. a designated
    /// initializer.
    case memberRef

    /// A reference to a labeled statement. This cursor kind is used to
    /// describe the jump to "start_over" in the  goto statement in the
    /// following example:
    /// ```
    /// start_over:
    ///   ++counter;
    ///   goto start_over;
    /// ```
    /// A label reference cursor refers to a label statement.
    case labelRef

    /// A reference to a set of overloaded functions or function templates
    /// that has not yet been resolved to a specific function or function
    /// template. An overloaded declaration reference cursor occurs in
    /// C++ templates where a dependent name refers to a function.
    /// For example:
    /// ```
    /// template<typename T> void swap(T&, T&);
    /// struct X { ... };
    /// void swap(X&, X&);
    /// template<typename T> void reverse(T* first, T* last) {
    ///   while (first < last) {
    ///     swap(*first, *—last);
    ///     ++first;
    ///   }
    /// }
    /// struct Y { };
    /// void swap(Y&, Y&);
    /// ```
    /// Here the identifier "swap" is associated with an overloaded
    /// declaration reference. In the template definition
    /// "swap" refers to either of the two "swap" functions declared
    /// above so both results will be available. At instantiation time
    /// "swap" may also refer to other functions found via argument-dependent
    /// lookup (e.g. the "swap" function at the end of the example).
    /// The functions `clang_getNumOverloadedDecls()` and
    /// `clang_getOverloadedDecl()` can be used to retrieve the definitions
    /// referenced by this cursor.
    case overloadedDeclRef

    /// A reference to a variable that occurs in some non-expression context
    /// e.g. a C++ lambda capture list.
    case variableRef

    /// MARK: Error conditions

    case invalidFile
    case noDeclFound

    case notImplemented

    case invalidCode

    /// MARK: Expressions

    /// An expression whose specific kind is not exposed via this interface.
    /// Unexposed expressions have the same operations as any other kind of
    /// expression; one can extract their location information, spelling
    /// children, etc. However, the specific kind of the expression is not reported.
    case unexposedExpr

    /// An expression that refers to some value declaration
    /// such as a function, variable, or enumerator.
    case declRefExpr

    /// An expression that refers to a member of a struct, union
    /// class, Objective-C class, etc.
    case memberRefExpr

    /// An expression that calls a function.
    case callExpr

    /// An expression that sends a message to an Objective-C
    /// object or class.
    case objcMessageExpr

    ///An expression that represents a block literal.
    case blockExpr

    /// An integer literal.
    case integerLiteral

    /// A floating point number literal.
    case floatingLiteral

    /// An imaginary number literal.
    case imaginaryLiteral

    /// A string literal.
    case stringLiteral

    /// A character literal.
    case characterLiteral

    /// A parenthesized expression, e.g. "(1)". This AST node is only
    /// formed if full location information is requested.
    case parenExpr

    /// This represents the unary-expression's (except sizeof and alignof).
    case unaryOperator

    /// [C99.5.2.1] Array Subscripting.
    case arraySubscriptExpr

    /// A builtin binary operation expression such as "x + y" or "x <= y".
    case binaryOperator

    /// Compound assignment such as "+=".
    case compoundAssignOperator

    /// The ?: ternary operator.
    case conditionalOperator

    /// An explicit cast in C (C99.5.4) or a C-style cast in C++ (C++ [expr.cast])
    /// which uses the syntax `(Type)expr`. For example:
    /// ```
    /// (int)f
    /// ```
    case cStyleCastExpr

    /// [C99.5.2.5]
    case compoundLiteralExpr

    /// Describes an C or C++ initializer list.
    case initListExpr

    /// The GNU address of label extension representing `&&label`.
    case addrLabelExpr

    /// This is the GNU Statement Expression extension: ({int X=4; X;})
    case stmtExpr

    /// Represents a C11 generic selection.
    case genericSelectionExpr

    /// Implements the GNU __null extension, which is a name for a null pointer
    /// constant that has integral type (e.g. int or long) and is the same size
    /// and alignment as a pointer. The __null extension is typically only used
    /// by system headers which define NULL as __null in C++ rather than using
    /// 0 (which is an integer that may not match the size of a pointer).
    case gnuNullExpr

    /// C++'s static_cast<> expression.
    case cxxStaticCastExpr

    /// C++'s dynamic_cast<> expression.
    case cxxDynamicCastExpr

    /// C++'s reinterpret_cast<> expression.
    case cxxReinterpretCastExpr

    /// C++'s const_cast<> expression.
    case cxxConstCastExpr

    /// Represents an explicit C++ type conversion that uses "functional"
    /// notation (C++ [expr.type.conv]). Example:
    /// ```
    /// x = int(0.5);
    /// ```
    case cxxFunctionalCastExpr

    /// A C++ typeid expression (C++ [expr.typeid]).
    case cxxTypeidExpr

    /// [C++.13.5] C++ Boolean Literal.
    case cxxBoolLiteralExpr

    /// [C++0x.14.7] C++ Pointer Literal.
    case cxxNullPtrLiteralExpr

    /// Represents the "this" expression in C++
    case cxxThisExpr

    /// [C++] C++ Throw Expression. This handles 'throw' and 'throw'
    /// assignment-expression. When assignment-expression isn't present,
    /// Op will be null.
    case cxxThrowExpr

    /// A new expression for memory allocation and constructor calls,
    /// e.g: "new CXXNewExpr(foo)".
    case cxxNewExpr

    /// A delete expression for memory deallocation and destructor calls
    /// e.g. "delete[] pArray".
    case cxxDeleteExpr

    /// A unary expression. (noexcept, sizeof, or other traits)
    case unaryExpr

    /// An Objective-C string literal i.e. @"foo".
    case objcStringLiteral

    /// An Objective-C \@encode expression.
    case objcEncodeExpr

    /// An Objective-C \@selector expression.
    case objcSelectorExpr

    /// An Objective-C \@protocol expression.
    case objcProtocolExpr

    /// An Objective-C "bridged" cast expression, which casts between
    /// Objective-C pointers and C pointers, transferring ownership in
    /// the process.
    /// ```
    /// NSString *str = (__bridge_transfer NSString *)CFCreateString();
    /// ```
    case objcBridgedCastExpr

    /// Represents a C++0x pack expansion that produces a sequence of expressions.
    /// A pack expansion expression contains a pattern (which itself is an expression)
    /// followed by an ellipsis. For example:
    /// ```
    /// template<typename F, typename ...Types> void forward(F f, Types &&...args) {
    ///   f(static_cast<Types&&>(args)...);
    /// }
    /// ```
    case packExpansionExpr

    /// Represents an expression that computes the length of a parameter pack.
    /// ```
    /// template<typename ...Types> struct count {
    ///   static const unsigned value = sizeof...(Types);
    /// };
    /// ```
    case sizeOfPackExpr

    /// Represents a C++ lambda expression that produces a local function object.
    /// ```
    /// void abssort(floatx, unsigned N) {
    ///   std::sort(x, x + N,
    ///             [](float a, float b) {
    ///               return std::abs(a) < std::abs(b);
    ///   });
    /// }
    /// ```
    case lambdaExpr

    /// Objective-c Boolean Literal.
    case objcBoolLiteralExpr

    /// Represents the "self" expression in an Objective-C method.
    case objcSelfExpr

    /// OpenMP.0 [2.4, Array Section].
    case ompArraySectionExpr

    /// Represents an @available(...) check.
    case objcAvailabilityCheckExpr

    /// MARK: Statements

    /// A statement whose specific kind is not exposed via this interface.
    /// Unexposed statements have the same operations as any other kind of
    /// statement; one can extract their location information, spelling, children,
    /// etc. However, the specific kind of the statement is not reported.
    case unexposedStmt

    /// A labelled statement in a function.  This cursor kind is used to describe
    /// the `start_over:` label statement in  the following example:
    /// ```
    /// start_over:
    ///   ++counter;
    /// ```
    case labelStmt

    /// A group of statements like { stmt stmt }. This cursor kind is used to
    /// describe compound statements, e.g. function bodies.
    case compoundStmt

    /// A case statement.
    case caseStmt

    /// A default statement.
    case defaultStmt

    /// An if statement
    case ifStmt

    /// A switch statement.
    case switchStmt

    /// A while statement.
    case whileStmt

    /// A do statement.
    case doStmt

    /// A for statement.
    case forStmt

    /// A goto statement.
    case gotoStmt

    /// An indirect goto statement.
    case indirectGotoStmt

    /// A continue statement.
    case continueStmt

    /// A break statement.
    case breakStmt

    /// A return statement.
    case returnStmt

    /// An inline assembly statement.
    case asmStmt

    /// Objective-C's overall \@try-\@catch-\@finally statement.
    case objcAtTryStmt

    /// Objective-C's \@catch statement.
    case objcAtCatchStmt

    /// Objective-C's \@finally statement.
    case objcAtFinallyStmt

    /// Objective-C's \@throw statement.
    case objcAtThrowStmt

    /// Objective-C's \@synchronized statement.
    case objcAtSynchronizedStmt

    /// Objective-C's autorelease pool statement.
    case objcAutoreleasePoolStmt

    /// Objective-C's collection statement.
    case objcForCollectionStmt

    /// C++'s catch statement.
    case cxxCatchStmt

    /// C++'s try statement.
    case cxxTryStmt

    /// C++'s for (* : *) statement.
    case cxxForRangeStmt

    /// Windows Structured Exception Handling's try statement.
    case sehTryStmt

    /// Windows Structured Exception Handling's except statement.
    case sehExceptStmt

    /// Windows Structured Exception Handling's finally statement.
    case sehFinallyStmt

    /// A MS inline assembly statement extension.
    case msAsmStmt

    /// The null statement ";": C99.8.3p3. This cursor kind is used to describe the null statement.
    case nullStmt

    /// Adaptor class for mixing declarations with statements and expressions.
    case declStmt

    /// OpenMP parallel directive.
    case ompParallelDirective

    /// OpenMP SIMD directive.
    case ompSimdDirective

    /// OpenMP for directive.
    case ompForDirective

    /// OpenMP sections directive.
    case ompSectionsDirective

    /// OpenMP section directive.
    case ompSectionDirective

    /// OpenMP single directive.
    case ompSingleDirective

    /// OpenMP parallel for directive.
    case ompParallelForDirective

    /// OpenMP parallel sections directive.
    case ompParallelSectionsDirective

    /// OpenMP task directive.
    case ompTaskDirective

    /// OpenMP master directive.
    case ompMasterDirective

    /// OpenMP critical directive.
    case ompCriticalDirective

    /// OpenMP taskyield directive.
    case ompTaskyieldDirective

    /// OpenMP barrier directive.
    case ompBarrierDirective

    /// OpenMP taskwait directive.
    case ompTaskwaitDirective

    /// OpenMP flush directive.
    case ompFlushDirective

    /// Windows Structured Exception Handling's leave statement.
    case sehLeaveStmt

    /// OpenMP ordered directive.
    case ompOrderedDirective

    /// OpenMP atomic directive.
    case ompAtomicDirective

    /// OpenMP for SIMD directive.
    case ompForSimdDirective

    /// OpenMP parallel for SIMD directive.
    case ompParallelForSimdDirective

    /// OpenMP target directive.
    case ompTargetDirective

    /// OpenMP teams directive.
    case ompTeamsDirective

    /// OpenMP taskgroup directive.
    case ompTaskgroupDirective

    /// OpenMP cancellation point directive.
    case ompCancellationPointDirective

    /// OpenMP cancel directive.
    case ompCancelDirective

    /// OpenMP target data directive.
    case ompTargetDataDirective

    /// OpenMP taskloop directive.
    case ompTaskLoopDirective

    /// OpenMP taskloop simd directive.
    case ompTaskLoopSimdDirective

    /// OpenMP distribute directive.
    case ompDistributeDirective

    /// OpenMP target enter data directive.
    case ompTargetEnterDataDirective

    /// OpenMP target exit data directive.
    case ompTargetExitDataDirective

    /// OpenMP target parallel directive.
    case ompTargetParallelDirective

    /// OpenMP target parallel for directive.
    case ompTargetParallelForDirective

    /// OpenMP target update directive.
    case ompTargetUpdateDirective

    /// OpenMP distribute parallel for directive.
    case ompDistributeParallelForDirective

    /// OpenMP distribute parallel for simd directive.
    case ompDistributeParallelForSimdDirective

    /// OpenMP distribute simd directive.
    case ompDistributeSimdDirective

    /// OpenMP target parallel for simd directive.
    case ompTargetParallelForSimdDirective

    /// Cursor that represents the translation unit itself. The translation
    /// unit cursor exists primarily to act as the root cursor for traversing
    /// the contents of a translation unit.
    case translationUnit

    /// MARK: Attributes

    /// An attribute whose specific kind is not exposed via this interface.
    case unexposedAttr
    case ibActionAttr
    case ibOutletAttr
    case ibOutletCollectionAttr
    case cxxFinalAttr
    case cxxOverrideAttr
    case annotateAttr
    case asmLabelAttr
    case packedAttr
    case pureAttr
    case constAttr
    case noDuplicateAttr
    case cudaConstantAttr
    case cudaDeviceAttr
    case cudaGlobalAttr
    case cudaHostAttr
    case cudaSharedAttr
    case visibilityAttr
    case dllExport
    case dllImport
    
    /// MARK: Preprocessing
    case preprocessingDirective
    case macroDefinition
    case macroExpansion
    
    case inclusionDirective
    
    /// MARK: Extra Declarations
    
    /// A module import declaration.
    case moduleImportDecl
    case typeAliasTemplateDecl
    
    /// A static_assert or _Static_assert node
    case staticAssert
    
    /// a friend declaration.
    case friendDecl
    
    /// A code completion overload candidate.
    case overloadCandidate
}
