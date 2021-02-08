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
        var output: O?
        
        func addOrFindNextNode(of component: RouterComponent) -> Node {
            let node = Node()
            switch component {
            case .constant(let string):
                if let exsitingNode = constants[string] {
                    return exsitingNode
                }
                constants[string] = node
            case .parameter(let name):
                if let (existingName, existingNode) = parameter {
                    assert(existingName == name, "Route parameter name mismatch \(existingName) != \(name)")
                    return existingNode
                }
                parameter = (name, node)
            case .catchall:
                if let node = catchall {
                    return node
                }
                catchall = node
            case .anything:
                if let node = anything {
                    return node
                }
                anything = node
            }
            return node
        }
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
        return self.map { "  " + $0 }
    }
}
