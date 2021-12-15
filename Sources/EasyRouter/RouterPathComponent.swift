//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/8.
//

import Foundation

public enum RouterPathComponent {
    case constant(String)
    case parameter(name: String)
    case anything
    case catchall
}

extension RouterPathComponent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let value = value.lowercased()
        if value.hasPrefix(":") {
            self = .parameter(name: String(value.dropFirst()))
        } else if value == "*" {
            self = .anything
        } else if value == "**" {
            self = .catchall
        } else {
            self = .constant(value)
        }
    }
}

extension RouterPathComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .anything:
            return "*"
        case .catchall:
            return "**"
        case .parameter(let name):
            return ":" + name
        case .constant(let constant):
            return constant
        }
    }
}

