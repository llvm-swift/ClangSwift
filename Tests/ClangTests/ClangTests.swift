import XCTest
#if !NO_SWIFTPM
import cclang
#endif
@testable import Clang

class ClangTests: XCTestCase {
    func testExample() {
        do {
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
