import XCTest
@testable import Clang

class ClangTests: XCTestCase {
    func testExample() {
        do {
            let index = Index()
            let tu = try TranslationUnit(index: index, filename: "/usr/local/include/debug.h",
                                         commandLineArgs: [])
            for child in tu.cursor.children() {
                print(child.kind)
            }
        } catch {
            XCTFail("\(error)")
        }
    }

    static var allTests : [(String, (ClangTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
