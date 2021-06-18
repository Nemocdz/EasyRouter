//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/4.
//

import Foundation

final class TrieRouter<O> {
    private let root = Node()
}

extension TrieRouter: URLRouter {
    func register(urlComponents: [String], output: O) {
        var currentNode = root
        let components = urlComponents.map { RouterComponent(stringLiteral: $0.lowercased()) }
        
        for component in components {
            currentNode = currentNode.addOrFindNextNode(of: component)
            if case .catchall = component {
                break
            }
        }
        
        if currentNode.output != nil {
            assertionFailure("url pattern is exist")
        }
        
        currentNode.output = output
    }
    
    func match(urlComponents: [String], parameters: inout RouterParameters) -> [O] {
        var currentNode = root
        var outputs = [Output]()
        var isEnd = true
        for component in urlComponents {
            // 尾通配符匹配
            if let node = currentNode.catchall {
                if let output = node.output {
                    outputs.append(output)
                }
            }
            
            if let node = currentNode.constants[component.lowercased()] {
                // 直接匹配
                currentNode = node
            } else if let (name, node) = currentNode.parameter {
                // 参数匹配
                if let component = component.removingPercentEncoding {
                    parameters.addValue(component, forKey: name)
                }
                currentNode = node
            } else if let node = currentNode.anything {
                // 通配符匹配
                currentNode = node
            } else {
                isEnd = false
                break
            }
        }
        
        if isEnd, let output = currentNode.output {
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


