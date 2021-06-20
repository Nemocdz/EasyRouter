//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/18.
//

import Foundation

public typealias RouterParameters = [String: [String]]

fileprivate let urlSet: CharacterSet = {
    var set = CharacterSet()
    set.formUnion(.urlHostAllowed)
    set.formUnion(.urlPathAllowed)
    set.formUnion(.urlQueryAllowed)
    set.formUnion(.urlFragmentAllowed)
    return set
}()

extension String {
    var routerComponents: [RouterComponent] {
        if let string = addingPercentEncoding(withAllowedCharacters: urlSet),
           let url = URL(string: string) {
            return url.urlComponents.map { RouterComponent(stringLiteral: $0) }
        }
        return []
    }
}

extension URL {
    var urlComponents: [String] {
        guard let scheme = scheme,
              !scheme.isEmpty,
              let host = host,
              !host.isEmpty else {
            return []
        }
        let allComponents = [scheme] + [host] + pathComponents.drop { $0 == "/" }
        return allComponents.map { $0.lowercased() }
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
        guard let value = value.removingPercentEncoding else { return }
        if var array = self[key] {
            array.append(value)
            self[key] = array
        } else {
            self[key] = Value([value])
        }
    }
}

public extension URL {
    static func build<T>(base: String,
                         queryParameters: T,
                         encoder: URLQueryItemsEncoder = .init()
    ) -> URL? where T: Encodable {
        var components = URLComponents(string: base)
        components?.queryItems = try? encoder.encode(queryParameters)
        return components?.url
    }
}
