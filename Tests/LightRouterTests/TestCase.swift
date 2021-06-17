//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation
import LightRouter

let patterns = [
    "a://**",
    "a://b/c",
    "a://b/**",
    "a://*/c",
    "a://b/:c/d",
    "a://b/:c/**",
]

let outputs = patterns

struct MatchResult {
    let paramters: URLRouterParameters
    let outputs: [String]
}

extension MatchResult: Equatable {
}

let matchCase: [(URL, MatchResult)] = [
    ("b://c", MatchResult(paramters: [:], outputs: [])),
    ("a://b", MatchResult(paramters: [:], outputs: [outputs[0]])),
    ("a://b/c", MatchResult(paramters: [:], outputs: [outputs[0], outputs[2], outputs[1]])),
    ("a://b/d", MatchResult(paramters: ["c":["d"]], outputs: [outputs[0], outputs[2]])),
    ("a://c/c", MatchResult(paramters: [:], outputs: [outputs[0], outputs[3]])),
    ("a://b/e/d", MatchResult(paramters: ["c":["e"]], outputs: [outputs[0], outputs[2], outputs[5], outputs[4]])),
    ("a://b/e/c", MatchResult(paramters: ["c":["e"]], outputs: [outputs[0], outputs[2], outputs[5]])),
    ("a://b/c/d", MatchResult(paramters: [:], outputs: [outputs[0], outputs[2]])),
]

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}
