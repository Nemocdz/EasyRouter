//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import Foundation

public final class URLQueryItemsEncoder {
    public var keyDecodingStrategy = KeyEncodingStrategy.useDefaultKeys
    public var userInfo = [CodingUserInfoKey: Any]()
    
    public init() { }
}

public extension URLQueryItemsEncoder {
    func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let options = Options(keyEncodingStrategy: .convertToSnakeCase, userInfo: userInfo)
        let encoder = Impl(options: options)
        if let value = try encoder.box(value) as? [URLQueryItem] {
            return value
        } else {
            let context = EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values.")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

public extension URLQueryItemsEncoder {
    enum KeyEncodingStrategy {
        case useDefaultKeys
        case convertToSnakeCase
        case custom((_ codingPath: [CodingKey]) -> CodingKey)
        
        static func convertToSnakeCase(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
            
            var words : [Range<String.Index>] = []
            var wordStart = stringKey.startIndex
            var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex
            
            while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
                let untilUpperCase = wordStart..<upperCaseRange.lowerBound
                words.append(untilUpperCase)
                searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
                guard let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
                    wordStart = searchRange.lowerBound
                    break
                }
                
                let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
                if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                    wordStart = upperCaseRange.lowerBound
                } else {
                    let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
                    words.append(upperCaseRange.lowerBound..<beforeLowerIndex)
                    wordStart = beforeLowerIndex
                }
                searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
            }
            words.append(wordStart..<searchRange.upperBound)
            let result = words.map({ (range) in
                return stringKey[range].lowercased()
            }).joined(separator: "_")
            return result
        }
    }
}

extension URLQueryItemsEncoder {
    struct Options {
        let keyEncodingStrategy: KeyEncodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
}


