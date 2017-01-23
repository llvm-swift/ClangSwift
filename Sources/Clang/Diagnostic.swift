import cclang

/// Describes the severity of a particular diagnostic.
public enum DiagnosticSeverity {

    /// A diagnostic that has been suppressed, e.g., by a command-line option.
    case ignored

    /// This diagnostic is a note that should be attached to the previous
    /// (non-note) diagnostic.
    case note

    /// This diagnostic indicates suspicious code that may not be wrong.
    case warning

    /// This diagnostic indicates that the code is ill-formed.
    case error

    /// This diagnostic indicates that the code is ill-formed such that future
    /// parser recovery is unlikely to produce useful results.
    case fatal

    init(clang: CXDiagnosticSeverity) {
        switch clang {
        case CXDiagnostic_Ignored: self = .ignored
        case CXDiagnostic_Note: self = .note
        case CXDiagnostic_Warning: self = .warning
        case CXDiagnostic_Error: self = .error
        case CXDiagnostic_Fatal: self = .fatal
        default: fatalError("invalid CXDiagnosticSeverity \(clang)")
        }
    }
}
