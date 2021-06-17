//
//  File.swift
//  
//
//  Created by Nemo on 2021/5/31.
//

import Foundation

public final class RouterParametersDecoder {
    public var keyDecodingStrategy = KeyDecodingStrategy.useDefaultKeys
    public var userInfo = [CodingUserInfoKey : Any]()
    
    public func decode<T : Decodable>(_ type: T.Type, from container: RouterParameters) throws -> T {
        let options = Options(keyDecodingStrategy: keyDecodingStrategy, userInfo: userInfo)
        let decoder = Impl(container: container, options: options)
        return try decoder.unbox(container, as: type)
    }
}

extension RouterParametersDecoder {
    public enum KeyDecodingStrategy {
        case useDefaultKeys
        case convertFromSnakeCase
        case custom((_ codingPath: [CodingKey]) -> CodingKey)
        
        static func convertFromSnakeCase(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
        
            guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
                return stringKey
            }
        
            var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
            while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
                stringKey.formIndex(before: &lastNonUnderscore)
            }
        
            let keyRange = firstNonUnderscore...lastNonUnderscore
            let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
            let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
        
            let components = stringKey[keyRange].split(separator: "_")
            let joinedString : String
            if components.count == 1 {
                joinedString = String(stringKey[keyRange])
            } else {
                joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
            }
        

            let result : String
            if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
                result = joinedString
            } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
                result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
            } else if (!leadingUnderscoreRange.isEmpty) {
                result = String(stringKey[leadingUnderscoreRange]) + joinedString
            } else {
                result = joinedString + String(stringKey[trailingUnderscoreRange])
            }
            return result
        }
    }
}

extension RouterParametersDecoder {
    struct Options {
        let keyDecodingStrategy: KeyDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
}
    
