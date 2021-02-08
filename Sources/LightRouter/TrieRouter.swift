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
    typealias Output = O

    func register(urlPattern: String, output: Output) {
        var currentNode = root
        let components = urlPattern.urlComponents.map { RouterComponent(stringLiteral: $0.lowercased()) }
        
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
    
    func match(url: URL, parameters: inout [String : String]) -> [Output] {
        var currentNode = root
        var outputs = [Output]()
        print(url.urlComponents)
        var isEnd = true
        for component in url.urlComponents {
            /// 尾通配符匹配
            if let node = currentNode.catchall {
                if let output = node.output {
                    outputs.append(output)
                }
            }
            
            if let node = currentNode.constants[component.lowercased()] {
                /// 直接匹配
                currentNode = node
            } else if let (name, node) = currentNode.parameter {
                /// 参数匹配
                if let component = component.removingPercentEncoding {
                    parameters[name] = component
                }
                
                currentNode = node
            } else if let node = currentNode.anything {
                /// 通配符匹配
                currentNode = node
            } else {
                isEnd = false
                break
            }
        }
        
        if isEnd, let output = currentNode.output {
            outputs.append(output)
        }
        
        parameters.merge(url.queryParameters) {
            assert($0 == $1, "duplicate query name")
            return $1
        }
        
        return outputs
    }
}

extension TrieRouter: CustomStringConvertible {
    var description: String {
        return root.description
    }
}

fileprivate extension String {
    var urlComponents: [String] {
        if let url = URL(string: self) {
            return url.urlComponents
        }
        
        if let string = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: string) {
            return url.urlComponents
        }
        
        return []
    }
}

fileprivate extension URL {
    var urlComponents: [String] {
        var allComponents = [String]()
        if let scheme = scheme {
            allComponents.append(scheme)
        }
        if let host = host {
            allComponents.append(host)
        }
        
        let _pathComponents = pathComponents.drop { $0 == "/" }
        
        allComponents.append(contentsOf: _pathComponents)
        return allComponents
    }
    
    var queryParameters: [String: String] {
        guard let items = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems else {
            return [:]
        }
        
        var result = [String: String]()
        
        items.forEach {
            guard let value = $0.value else { return }
            assert(result.keys.contains($0.name), "duplicate query name")
            result[$0.name] = value
        }
        
        return result
    }
}




