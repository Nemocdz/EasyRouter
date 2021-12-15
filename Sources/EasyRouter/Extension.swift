//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/18.
//

import Foundation

fileprivate let urlSet: CharacterSet = {
    var set = CharacterSet()
    set.formUnion(.urlHostAllowed)
    set.formUnion(.urlPathAllowed)
    set.formUnion(.urlQueryAllowed)
    set.formUnion(.urlFragmentAllowed)
    return set
}()

extension String {
    var urlComponents: [String] {
        if let string = addingPercentEncoding(withAllowedCharacters: urlSet),
           let url = URL(string: string) {
            return url.urlComponents
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
    init?<T>(base: String,
            queryParameters: T,
            encoder: URLQueryItemsEncoder = .init()
    ) where T: Encodable {
        var components = URLComponents(string: base)
        components?.queryItems = try? encoder.encode(queryParameters)
        if let url = components?.url {
            self = url
        } else {
            return nil
        }
    }
}
