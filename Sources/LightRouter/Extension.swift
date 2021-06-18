//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/18.
//

import Foundation

public typealias RouterParameters = [String: [String]]

extension String {
    var urlComponents: [String] {
        if let string = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: string) {
            return url.urlComponents
        }
        return []
    }
}

extension URL {
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

extension RouterParameters {
    mutating func addValue(_ value: Value.Element, forKey key: Key) {
        if var array = self[key] {
            array.append(value)
            self[key] = array
        } else {
            self[key] = Value([value])
        }
    }
}
