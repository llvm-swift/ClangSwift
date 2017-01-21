import XCTest
@testable import Clang

class ClangTests: XCTestCase {
    func testExample() {
        do {
            let index = Index()
            let tu = try TranslationUnit(index: index, filename: "/Users/harlan/foo.h", commandLineArgs: [])
            for child in tu.cursor.children() {
                print(child.kind)
                if let record = child as? RecordDecl {
                    for child in record.children() {
                        print("\(child): \(child.type!)")
                    }
                }
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
