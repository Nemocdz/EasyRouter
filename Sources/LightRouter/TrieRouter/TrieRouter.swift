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
    
    func match(url: URL, parameters: inout RouterParameters) -> [Output] {
        var currentNode = root
        var outputs = [Output]()
        var isEnd = true
        for component in url.urlComponents {
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
        
        url.queryItems.forEach {
            if let value = $0.value {
                parameters.addValue(value, forKey: $0.name)
            }
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
    
    var queryItems: [URLQueryItem] {
        guard let items = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems else {
            return []
        }
        return items
    }
}

fileprivate extension RouterParameters {
    mutating func addValue(_ value: Value.Element, forKey key: Key) {
        if var array = self[key] {
            array.append(value)
            self[key] = array
        } else {
            self[key] = Value([value])
        }
    }
}




