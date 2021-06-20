//
//  File.swift
//
//
//  Created by Nemo on 2021/6/8.
//

@testable import LightRouter
import XCTest

final class TrieRouterTests: XCTestCase {
    enum Pattern: String, CaseIterable {
        case a = "a://**"
        case b = "a://b/c"
        case c = "a://b/**"
        case d = "a://*/c"
        case e = "a://b/:c/d"
        case f = "a://b/:c/**"
        
        var output: String { rawValue }
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
            trie.register(components: $0.rawValue.routerComponents, output: $0.output)
        }
        
        print(trie)
    }
    
    func testCase1() {
        let url: URL = "b://c"
        let result = MatchResult(paramters: [:], patterns: [])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase2() {
        let url: URL = "a://b"
        let result = MatchResult(paramters: [:], patterns: [.a])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase3() {
        let url: URL = "a://b/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .c, .b])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase4() {
        let url: URL = "a://b/d"
        let result = MatchResult(paramters: ["c": ["d"]], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase5() {
        let url: URL = "a://c/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .d])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase6() {
        let url: URL = "a://b/e/d"
        let result = MatchResult(paramters: ["c": ["e"]], patterns: [.a, .c, .f, .e])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase7() {
        let url: URL = "a://b/e/c"
        let result = MatchResult(paramters: ["c": ["e"]], patterns: [.a, .c, .f])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testCase8() {
        let url: URL = "a://b/c/d"
        let result = MatchResult(paramters: [:], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        
        XCTAssert(parameters == result.paramters)
        XCTAssert(outputs == result.outputs)
    }
    
    func testInvaildPattern() {
        let noScheme = "b/c/d"
        let notURL = "b"
        
        XCTAssert(noScheme.routerComponents.isEmpty)
        XCTAssert(notURL.routerComponents.isEmpty)
    }
    
    func testOverridePattern() {
        let pattern = "b://c"
        let url: URL = "b://c"
        var p = RouterParameters()
        
        let output1 = "1"
        trie.register(components: pattern.routerComponents, output: output1)
        XCTAssertEqual(trie.match(urlComponents: url.urlComponents, parameters: &p), [output1])
        
        let output2 = "2"
        trie.register(components: pattern.routerComponents, output: output2)
        XCTAssertEqual(trie.match(urlComponents: url.urlComponents, parameters: &p), [output2])
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
        ("testInvaildPattern", testInvaildPattern),
        ("testOverridePattern", testOverridePattern)
    ]
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}
