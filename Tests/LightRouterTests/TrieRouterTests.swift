import XCTest
@testable import LightRouter

final class TrieRouterTests: XCTestCase {
    enum Pattern: String, CaseIterable {
        case a = "a://**"
        case b = "a://b/c"
        case c = "a://b/**"
        case d = "a://*/c"
        case e = "a://b/:c/d"
        case f = "a://b/:c/**"
        
        var output: String {
            self.rawValue
        }
    }
    
    struct MatchResult {
        let paramters: RouterParameters
        let patterns: [Pattern]
        
        var outputs: [String] {
            patterns.map(\.output)
        }
    }
    
    var trie = TrieRouter<String>()
        
    override func setUp() {
        trie = TrieRouter<String>()
        Pattern.allCases.forEach {
            trie.register(urlPattern: $0.rawValue, output: $0.output)
        }
    }
    
    func testCase1() {
        let url: URL = "b://c"
        let result = MatchResult(paramters: [:], patterns: [])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase2() {
        let url: URL = "a://b"
        let result = MatchResult(paramters: [:], patterns: [.a])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase3() {
        let url: URL = "a://b/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .c, .b])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase4() {
        let url: URL = "a://b/d"
        let result = MatchResult(paramters: ["c":["d"]], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase5() {
        let url: URL = "a://c/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .d])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase6() {
        let url: URL = "a://b/e/d"
        let result = MatchResult(paramters: ["c":["e"]], patterns: [.a, .c, .f, .e])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase7() {
        let url: URL = "a://b/e/c"
        let result = MatchResult(paramters: ["c":["e"]], patterns: [.a, .c, .f])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase8() {
        let url: URL = "a://b/c/d"
        let result = MatchResult(paramters: [:], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(url: url, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }

    static var allTests = [
        ("testCase1", testCase1),
        ("testCase2", testCase2),
        ("testCase3", testCase3),
        ("testCase4", testCase4),
        ("testCase5", testCase5),
        ("testCase6", testCase6),
        ("testCase7", testCase7),
        ("testCase8", testCase8),
    ]
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}
