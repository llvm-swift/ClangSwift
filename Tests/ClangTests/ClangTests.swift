import XCTest
import cclang
@testable import Clang

extension String {
    var lowercasingFirstWord: String {
        var wordIndex = startIndex
        let thresholdIndex = index(wordIndex, offsetBy: 1)
        for c in unicodeScalars {
            if islower(Int32(c.value)) != 0 {
                if wordIndex > thresholdIndex {
                    wordIndex = index(before: wordIndex)
                }
                break
            }
            wordIndex = index(after: wordIndex)
        }
        if wordIndex == startIndex {
            return self
        }
        return substring(to: wordIndex).lowercased() + substring(from: wordIndex)
    }

    func wrapped(to columns: Int = 80) -> [String] {
        let scanner = Scanner(string: self)

        var result = [String]()
        var current = ""
        var currentLineLength = 0

        var word: NSString?
        while scanner.scanUpToCharacters(from: .whitespacesAndNewlines,
                                         into: &word), let word = word {
            let wordLength = word.length

            if currentLineLength != 0 && currentLineLength + wordLength + 1 > columns {
                // too long for current line, wrap
                result.append(current)
                current = ""
                currentLineLength = 0
            }

            // append the word
            if currentLineLength != 0 {
                current.append(" ")
                currentLineLength += 1
            }
            current += word as String
            currentLineLength += wordLength
        }

        if !current.isEmpty {
            result.append(current)
        }
        return result
    }
}

func generateSwiftEnum(forEnum decl: EnumDecl, prefix: String, name: String) {
    var pairs = [(String, String, EnumConstantDecl)]()
    if let comment = decl.fullComment {
        for line in convert(comment) {
            print(line)
        }
    }
    print("enum \(name) {")
    for child in decl.constants() {
        let constantName = "\(child)"
        let name = constantName.replacingOccurrences(of: prefix, with: "")
                               .lowercasingFirstWord
        pairs.append((constantName, name, child))
    }
    for (_, name, decl) in pairs {
        if let comment = decl.fullComment {
            print()
            for section in convert(comment) {
                print("  \(section)")
            }
        }
        print("  case \(name)")
    }
    print()
    print("  init(clang: \(decl)) {")
    print("    switch clang {")
    for (constant, name, _) in pairs {
        print("    case \(constant): self = .\(name)")
    }
    print("    default: fatalError(\"invalid \(decl) \\(clang)\")")
    print("    }")
    print("  }")
    print("}")
}

func generateStructs(forEnum decl: EnumDecl,
                     type: String,
                     prefix: String,
                     suffix: String = "") {
    let protocolDecl = [
        "protocol \(type) {",
        "  var clang: CX\(type) { get }",
        "}",
        ""
    ].joined(separator: "\n")
    var structDecls = [String]()
    var conversionCases = [String]()
    for child in decl.constants() {
        let typeName = "\(child)".replacingOccurrences(of: prefix, with: "")
        if typeName.hasPrefix("First") || typeName.hasPrefix("Last") { continue }
        let structName = "\(typeName)\(suffix)"
        var pieces = [
            "struct \(structName): \(type) {",
            "  let clang: CX\(type)",
            "}",
            ""
        ]
        if let comment = child.fullComment {
            pieces.insert(contentsOf: convert(comment), at: 0)
        }
        structDecls.append(pieces.joined(separator: "\n"))
        conversionCases.append("case \(child): return \(structName)(clang: clang)")
    }

    print(protocolDecl)
    for structDecl in structDecls {
        print(structDecl)
    }
    print("/// Converts a CX\(type) to a \(type), returning `nil` if it was " +
          "unsuccessful")
    print("func convert\(type)(_ clang: CX\(type)) -> \(type)? {")
    print("  if <#clang thing is null?#> { return nil }")
    print("  switch <#Get clang kind#> {")
    for caseDecl in conversionCases {
        print("  \(caseDecl)")
    }
    print("  default: fatalError(\"invalid CX\(type)Kind \\(clang)\")")
    print("  }")
    print("}")
}

/// Performs a BFS over the comment text and converts it into Swift-compatible
/// comments. Very quick&dirty, and will require manual edits.
func convert(_ comment: FullComment) -> [String] {
    var sections = [String]()
    var queue = [Comment]()
    queue.append(comment)
    while !queue.isEmpty {
        let next = queue.removeFirst()
        if let para = next as? ParagraphComment {
            if let textChildren = Array(para.children) as? [TextComment] {
                let text = textChildren.map { $0.text }.joined()
                sections.append(contentsOf: text.wrapped(to: 76))
                continue
            }
        } else if let textComment = next as? TextComment {
            sections.append(contentsOf: textComment.text.wrapped(to: 76))
        } else if let block = next as? VerbatimBlockCommandComment {
            sections.append("```")
            for child in block.children {
                guard let verbatim = child as? VerbatimBlockLineComment else { continue }
                sections.append(verbatim.text)
            }
            sections.append("```")
        } else if
            // Check if we've got a brief declaration that's
            // got text inside it, and it put before anything else.
            let brief = next as? BlockCommandComment,
            brief.name == "brief",
            let para = brief.firstChild as? ParagraphComment,
            let text = Array(para.children) as? [TextComment] {
            sections.insert(text.map { $0.text }.joined(separator: " "), at: 0)
            queue.append(contentsOf: brief.children.dropFirst())
            continue
        }
        queue.append(contentsOf: next.children)
    }
    return sections.lazy
                   .map { $0.trimmingCharacters(in: .whitespaces) }
                   .filter { !$0.isEmpty }
                   .map { "/// \($0)" }
}



class ClangTests: XCTestCase {
    func testExample() {
        do {
            let index = Index()
            let tu = try TranslationUnit(index: index,
                                         filename: "/usr/local/opt/llvm/include/clang-c/Index.h",
                                         commandLineArgs: [
                                            "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
                                            "-I/usr/local/opt/llvm/include"
                                            ])
            let typesToMake: [String: (type: String, prefix: String, suffix: String)] = [
                "CXTemplateArgumentKind": (type: "TemplateArgumentKind", prefix: "CXTemplateArgumentKind_", suffix: "")
            ]
            for child in tu.cursor.children() {
                guard let enumDecl = child as? EnumDecl else { continue }
                if let values = typesToMake["\(enumDecl)"] {
                    generateSwiftEnum(forEnum: enumDecl, prefix: values.prefix, name: values.type)
//                    generateStructs(forEnum: enumDecl, type: values.type,
//                                    prefix: values.prefix, suffix: values.suffix)
                }
            }
//            for child in tu.cursor.children() {
//                guard let function = child as? FunctionDecl else { continue }
//                let funcName = "\(function)"
//                guard funcName.hasPrefix("clang_Cursor_get") else { continue }
//                let varName = funcName.replacingOccurrences(of: "clang_Cursor_get", with: "")
//                                      .lowercasingFirstWord
//                print("var \(varName): \(function.resultType!)")
//            }
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
