import XCTest
@testable import ClangSwift

class ClangSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(ClangSwift().text, "Hello, World!")
    }


    static var allTests : [(String, (ClangSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
