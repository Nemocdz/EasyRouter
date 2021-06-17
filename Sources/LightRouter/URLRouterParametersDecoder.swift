//
//  File.swift
//  
//
//  Created by Nemo on 2021/5/31.
//

import Foundation

public class URLRouterParametersDecoder {
    public var keyDecodingStrategy = KeyDecodingStrategy.useDefaultKeys
    public var userInfo = [CodingUserInfoKey : Any]()
    
    public func decode<T : Decodable>(_ type: T.Type, from container: URLRouterParameters) throws -> T {
        let options = Options(keyDecodingStrategy: keyDecodingStrategy, userInfo: userInfo)
        let decoder = DecoderImpl(container: container, options: options)
        return try decoder.unbox(container, as: type)
    }
}

extension URLRouterParametersDecoder {
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

extension URLRouterParametersDecoder {
    struct Options {
        let keyDecodingStrategy: KeyDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
}

extension URLRouterParametersDecoder {
    class DecoderImpl: Decoder {
        var storage = Storage()
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey : Any] { options.userInfo }
        let options: Options
        
        init(container: URLRouterParameters, options: Options, codingPath: [CodingKey] = []) {
            storage.push(container: container)
            self.options = options
            self.codingPath = codingPath
        }
        
        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            let container = KeyedContainer<Key>(decoder: self, container: try castOrThrow(storage.topContainer, as: URLRouterParameters.self))
            return KeyedDecodingContainer(container)
        }
        
        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            return UnkeyedContanier(decoder: self, container: try castOrThrow(storage.topContainer, as: [URLRouterParameters.Value.Element].self))
        }
        
        func singleValueContainer() throws -> SingleValueDecodingContainer {
            return SingleValueContainer(decoder: self)
        }
    }
}

extension URLRouterParametersDecoder {
    struct Storage {
        private(set) var containers: [Any] = []

        var count: Int { containers.count }

        var topContainer: Any {
            precondition(!self.containers.isEmpty, "Empty container stack.")
            return containers.last!
        }

        mutating func push(container: Any) {
            containers.append(container)
        }

        mutating func popContainer() {
            precondition(!self.containers.isEmpty, "Empty container stack.")
            containers.removeLast()
        }
    }
}

extension URLRouterParametersDecoder {
    struct AnyCodingKey : CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        
        init(stringValue: String, intValue: Int?) {
            self.stringValue = stringValue
            self.intValue = intValue
        }

        init(index: Int) {
            self.stringValue = "Index \(index)"
            self.intValue = index
        }
        
        static let `super` = AnyCodingKey(stringValue: "super")!
    }
}

extension URLRouterParametersDecoder.DecoderImpl {
    func castOrThrow<T>(_ value: Any, as type: T.Type) throws -> T {
        guard let returnValue = value as? T else {
            let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.typeMismatch(T.self, context)
        }
        return returnValue
    }
    
    func unbox<T: Decodable>(_ value: Any, as type: T.Type) throws -> T {
        do {
            return try castOrThrow(value, as: type)
        } catch {
            storage.push(container: value)
            defer { storage.popContainer() }
            return try T(from: self)
        }
    }
}

extension URLRouterParametersDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: DecoderImpl
        
        var codingPath: [CodingKey] { decoder.codingPath }
        
        private func currentValue() throws -> String {
            return try decoder.castOrThrow(decoder.storage.topContainer, as: String.self)
        }
        
        func decodeNil() -> Bool {
            return decoder.storage.count == 0
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            let value = try currentValue()
            if let value = Bool(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: String.Type) throws -> String {
            return try currentValue()
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            let value = try currentValue()
            if let value = Double(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            let value = try currentValue()
            if let value = Float(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            let value = try currentValue()
            if let value = Int(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            let value = try currentValue()
            if let value = Int8(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            let value = try currentValue()
            if let value = Int16(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            let value = try currentValue()
            if let value = Int32(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            let value = try currentValue()
            if let value = Int64(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            let value = try currentValue()
            if let value = UInt(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            let value = try currentValue()
            if let value = UInt8(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            let value = try currentValue()
            if let value = UInt16(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            let value = try currentValue()
            if let value = UInt32(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            let value = try currentValue()
            if let value = UInt64(value) {
                return value
            } else {
                let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.typeMismatch(type, context)
            }
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let value = try currentValue()
            return try decoder.unbox(value, as: type)
        }
    }
    
    struct UnkeyedContanier: UnkeyedDecodingContainer {
        let decoder: DecoderImpl
        let container: [URLRouterParameters.Value.Element]
        
        var codingPath: [CodingKey] { decoder.codingPath }

        var count: Int? { container.count }
        
        var isAtEnd: Bool { currentIndex >= container.count }
        
        var currentIndex: Int = 0
                
        private func checkIndex<T>(_ type: T.Type) throws {
            if isAtEnd {
                let path = decoder.codingPath + [AnyCodingKey(index: currentIndex)]
                let error = DecodingError.Context(codingPath: path, debugDescription: "container is at end.")
                throw DecodingError.valueNotFound(T.self, error)
            }
        }
        
        private mutating func _decode<T: Decodable>(_ type: T.Type) throws -> T {
            try checkIndex(type)
            decoder.codingPath.append(AnyCodingKey(index: currentIndex))
            defer {
                decoder.codingPath.removeLast()
                currentIndex += 1
            }
            let value = container[currentIndex]
            return try decoder.unbox(value, as: type)
        }
        
        mutating func decodeNil() throws -> Bool {
            try checkIndex(String.self)
            return false
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool {
            return try _decode(type)
        }
        
        mutating func decode(_ type: String.Type) throws -> String {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Double.Type) throws -> Double {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Float.Type) throws -> Float {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Int.Type) throws -> Int {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: UInt.Type) throws -> UInt {
            return try _decode(type)
        }
        
        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try _decode(type)
        }
        
        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try _decode(type)
        }
        
        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            return try _decode(type)
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            try checkIndex(type)
            decoder.codingPath.append(AnyCodingKey(index: currentIndex))
            defer {
                decoder.codingPath.removeLast()
                currentIndex += 1
            }
            let value = container[currentIndex]
            let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.typeMismatch(type, context)
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let type = [String].self
            try checkIndex(type.self)
            decoder.codingPath.append(AnyCodingKey(index: currentIndex))
            defer {
                decoder.codingPath.removeLast()
                currentIndex += 1
            }
            let value = container[currentIndex]
            let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.typeMismatch(type, context)
        }
        
        mutating func superDecoder() throws -> Decoder {
            fatalError("unreachable")
        }
    }
    
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let decoder: DecoderImpl
        let container: URLRouterParameters
        
        init(decoder: DecoderImpl, container: URLRouterParameters) {
            self.decoder = decoder
            switch decoder.options.keyDecodingStrategy {
            case .useDefaultKeys:
                self.container = container
            case .convertFromSnakeCase:
                self.container = URLRouterParameters(
                    container.map {
                        (KeyDecodingStrategy.convertFromSnakeCase($0), $1)
                    }, uniquingKeysWith: { first, _ in first })
            case .custom(let converter):
                self.container = URLRouterParameters(
                    container.map {
                        (converter(decoder.codingPath + [AnyCodingKey(stringValue: $0, intValue: nil)]).stringValue, $1)
                }, uniquingKeysWith: { first, _ in first })
            }
        }
        
        var codingPath: [CodingKey] { decoder.codingPath }
        
        var allKeys: [Key] { container.keys.compactMap { Key(stringValue: $0) } }
        
        private func find(for key: CodingKey) throws -> URLRouterParameters.Value.Element {
            if let first = findValues(for: key).first {
                return first
            } else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\").")
                throw DecodingError.keyNotFound(key, context)
            }
        }
        
        private func findValues(for key: CodingKey) -> URLRouterParameters.Value {
            if let value = container[key.stringValue] {
                return value
            } else {
                return []
            }
        }
        
        private func _decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let value = try find(for: key)
            return try decoder.unbox(value, as: type)
        }
        
        func contains(_ key: Key) -> Bool {
            if let value = container[key.stringValue], !value.isEmpty {
                return true
            } else {
                return false
            }
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            return !contains(key)
        }
        
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            return try _decode(type, forKey: key)
        }
        
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            return try _decode(type, forKey: key)
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            do {
                let value = findValues(for: key)
                return try decoder.unbox(value, as: type)
            } catch {
                let value = try find(for: key)
                return try decoder.unbox(value, as: type)
            }
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let value = try find(for: key)
            let description = "Expected to decode \(type) but found \(Swift.type(of: value)) instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.typeMismatch(type, context)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let value = findValues(for: key)
            return UnkeyedContanier(decoder: decoder, container: value)
        }
        
        func superDecoder() throws -> Decoder {
            fatalError("unreachable")
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError("unreachable")
        }
    }
}




