import XCTest
@testable import LightRouter

final class LightRouterTests: XCTestCase {
    var trie = TrieRouter<String>()
    
    override func setUp() {
        trie = TrieRouter<String>()
        zip(patterns, outputs).forEach { (pattern, output) in
            trie.register(urlPattern: pattern, output: output)
        }
    }
    
    func testExample() {
        matchCase.forEach { (url, expect) in
            var parameters = URLRouterParameters()
            let outputs = trie.match(url: url, parameters: &parameters)
            let result = MatchResult(paramters: parameters, outputs: outputs)
            XCTAssert(result == expect, "case url: \(url)")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
