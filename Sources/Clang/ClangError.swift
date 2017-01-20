import cclang

/// Represents the errors that can be thrown by libclang.
enum ClangError: Error {
    static let mapping: [CXErrorCode.RawValue: ClangError] = [
        CXError_Failure.rawValue: .failure, CXError_Crashed.rawValue: .crashed,
        CXError_ASTReadError.rawValue: .astRead, CXError_InvalidArguments.rawValue: .invalidArguments
    ]
    case failure, crashed, invalidArguments, astRead
    init?(clang: CXErrorCode) {
        guard let val = ClangError.mapping[clang.rawValue] else { return nil }
        self = val
    }
}
