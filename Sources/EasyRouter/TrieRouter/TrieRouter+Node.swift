//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

extension TrieRouter {
    final class Node {
        var constants = [String : Node]()
        var parameter: (name: String, node: Node)?
        var anything: Node?
        var catchall: Node?
        var output: T?
    }
}

extension TrieRouter.Node: CustomStringConvertible {
    var description: String {
        return subpathDescriptions.joined(separator: "\n")
    }
    
    private var subpathDescriptions: [String] {
        var desc: [String] = []
        for (name, constant) in constants {
            desc.append("→ \(name)")
            desc += constant.subpathDescriptions.indented()
        }
        if let (name, parameter) = parameter {
            desc.append("→ :\(name)")
            desc += parameter.subpathDescriptions.indented()
        }
        if let anything = anything {
            desc.append("→ *")
            desc += anything.subpathDescriptions.indented()
        }
        if let _ = catchall {
            desc.append("→ **")
        }
        return desc
    }
}

fileprivate extension Array where Element == String {
    func indented() -> [String] {
        return map { "  " + $0 }
    }
}
