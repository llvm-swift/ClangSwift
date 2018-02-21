import XCTest
#if SWIFT_PACKAGE
  import cclang
#endif
@testable import Clang

class ClangTests: XCTestCase {
  func testInitUsingStringAsSource() {
    do {
      let unit = try TranslationUnit(clangSource: "int main() {}", language: .c)
      let lexems =
        unit.tokens(in: unit.cursor.range).map {$0.spelling(in: unit)}
      XCTAssertEqual(lexems, ["int", "main", "(", ")", "{", "}"])
    } catch {
      XCTFail("\(error)")
    }
  }

  static var allTests : [(String, (ClangTests) -> () throws -> Void)] {
    return [
      ("testInitUsingStringAsSource", testInitUsingStringAsSource),
    ]
  }
}
