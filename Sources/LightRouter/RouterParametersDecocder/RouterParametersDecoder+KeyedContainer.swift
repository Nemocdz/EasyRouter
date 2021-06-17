//
//  File.swift
//
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

extension RouterParametersDecoder {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let decoder: Impl
        let container: RouterParameters
    
        init(decoder: Impl, container: RouterParameters) {
            self.decoder = decoder
            switch decoder.options.keyDecodingStrategy {
            case .useDefaultKeys:
                self.container = container
            case .convertFromSnakeCase:
                self.container = RouterParameters(
                    container.map {
                        (KeyDecodingStrategy.convertFromSnakeCase($0), $1)
                    }, uniquingKeysWith: { first, _ in first })
            case .custom(let converter):
                self.container = RouterParameters(
                    container.map {
                        (converter(decoder.codingPath + [AnyCodingKey(stringValue: $0, intValue: nil)]).stringValue, $1)
                    }, uniquingKeysWith: { first, _ in first })
            }
        }
    
        var codingPath: [CodingKey] { decoder.codingPath }
    
        var allKeys: [Key] { container.keys.compactMap { Key(stringValue: $0) } }
    
        private func find(for key: CodingKey) throws -> RouterParameters.Value.Element {
            if let first = findValues(for: key).first {
                return first
            } else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\").")
                throw DecodingError.keyNotFound(key, context)
            }
        }
    
        private func findValues(for key: CodingKey) -> RouterParameters.Value {
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
    
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
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
    
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
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
