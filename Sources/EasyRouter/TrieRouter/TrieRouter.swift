//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/4.
//

import Foundation

class TrieRouter<T> {
    private let root = Node()
}

extension TrieRouter: URLRouter {
    func register(pathComponents: [RouterPathComponent], output: T) {
        var currentNode = root
        pathComponents.forEach { component in
            func addOrFindNextNode(of component: RouterPathComponent) -> Node {
                let node = Node()
                switch component {
                case .constant(let value):
                    if let node = currentNode.constants[value] {
                        return node
                    }
                    currentNode.constants[value] = node
                case .parameter(let name):
                    if let (_, node) = currentNode.parameter {
                        currentNode.parameter = (name, node)
                        return node
                    }
                    currentNode.parameter = (name, node)
                case .catchall:
                    if let node = currentNode.catchall {
                        return node
                    }
                    currentNode.catchall = node
                case .anything:
                    if let node = currentNode.anything {
                        return node
                    }
                    currentNode.anything = node
                }
                return node
            }
            currentNode = addOrFindNextNode(of: component)
        }
        currentNode.output = output
    }
    
    func match(components: [String], parameters: inout RouterParameters) -> [T] {
        var currentNode = root
        var outputs = [Output]()
        var isMatch = true
        for component in components {
            if let node = currentNode.catchall, let output = node.output {
                outputs.append(output)
            }
            if let node = currentNode.constants[component] {
                currentNode = node
            } else if let (name, node) = currentNode.parameter {
                parameters.addValue(component, forKey: name)
                currentNode = node
            } else if let node = currentNode.anything {
                currentNode = node
            } else {
                isMatch = false
                break
            }
        }
        if isMatch, let output = currentNode.output {
            outputs.append(output)
        }
        return outputs
    }
}

extension TrieRouter: CustomStringConvertible {
    var description: String {
        return root.description
    }
}


