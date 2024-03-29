//
//  File.swift
//
//
//  Created by Nemo on 2021/6/8.
//

@testable import EasyRouter
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
            trie.register(pathComponents: $0.rawValue.pathComponets, output: $0.output)
        }
        print(trie)
    }
    
    func testCase1() {
        let url: URL = "b://c"
        let result = MatchResult(paramters: [:], patterns: [])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase2() {
        let url: URL = "a://b"
        let result = MatchResult(paramters: [:], patterns: [.a])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase3() {
        let url: URL = "a://b/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .c, .b])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase4() {
        let url: URL = "a://b/d"
        let result = MatchResult(paramters: ["c": ["d"]], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase5() {
        let url: URL = "a://c/c"
        let result = MatchResult(paramters: [:], patterns: [.a, .d])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase6() {
        let url: URL = "a://b/e/d"
        let result = MatchResult(paramters: ["c": ["e"]], patterns: [.a, .c, .f, .e])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase7() {
        let url: URL = "a://b/e/c"
        let result = MatchResult(paramters: ["c": ["e"]], patterns: [.a, .c, .f])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testCase8() {
        let url: URL = "a://b/c/d"
        let result = MatchResult(paramters: [:], patterns: [.a, .c])
        
        var parameters = RouterParameters()
        let outputs = trie.match(components: url.urlComponents, parameters: &parameters)
        
        XCTAssertEqual(parameters, result.paramters)
        XCTAssertEqual(outputs, result.outputs)
    }
    
    func testInvaildPattern() {
        let noScheme = "b/c/d"
        let notURL = "b"
        let noHost = "a://:c"
        
        XCTAssert(noScheme.urlComponents.isEmpty)
        XCTAssert(notURL.urlComponents.isEmpty)
        XCTAssert(noHost.urlComponents.isEmpty)
    }
    
    func testOverridePattern1() {
        let pattern = "b://c"
        let url: URL = "b://c"
        var p = RouterParameters()
        
        let output1 = "1"
        trie.register(pathComponents: pattern.pathComponets, output: output1)
        XCTAssertEqual(trie.match(components: url.urlComponents, parameters: &p), [output1])
        
        let output2 = "2"
        trie.register(pathComponents: pattern.pathComponets, output: output2)
        XCTAssertEqual(trie.match(components: url.urlComponents, parameters: &p), [output2])
    }
    
    func testOverridePattern2() {
        let url: URL = "c://a/1"
        
        let pattern = "c://a/:b"
        let output1 = "1"
        var p1 = RouterParameters()
        trie.register(pathComponents: pattern.pathComponets, output: output1)
        XCTAssertEqual(trie.match(components: url.urlComponents, parameters: &p1), [output1])
        XCTAssertEqual(p1["b"], ["1"])
        
        let pattern2 = "c://a/:c"
        let output2 = "2"
        var p2 = RouterParameters()
        trie.register(pathComponents: pattern2.pathComponets, output: output2)
        XCTAssertEqual(trie.match(components: url.urlComponents, parameters: &p2), [output2])
        XCTAssertEqual(p2["c"], ["1"])
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
        ("testOverridePattern1", testOverridePattern1),
        ("testOverridePattern2", testOverridePattern2),
    ]
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}

extension String {
    var pathComponets: [RouterPathComponent] {
        urlComponents.map { RouterPathComponent(stringLiteral: $0) }
    }
}
