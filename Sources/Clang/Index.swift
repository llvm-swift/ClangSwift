import cclang

public class Index {
    let clang: CXIndex

    public init(excludeDeclarationsFromPCH: Bool = true,
                displayDiagnostics: Bool = true) {
        self.clang = clang_createIndex(excludeDeclarationsFromPCH.asClang(),
                                       displayDiagnostics.asClang())
    }

    deinit {
        clang_disposeIndex(clang)
    }
}
