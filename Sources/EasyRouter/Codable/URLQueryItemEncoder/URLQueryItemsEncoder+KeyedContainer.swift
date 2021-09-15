//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import Foundation

extension URLQueryItemsEncoder {
    struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        let encoder: Impl
        var codingPath: [CodingKey] { encoder.codingPath }

        init(encoder: Impl) {
            self.encoder = encoder
            encoder.storage.push(container: [URLQueryItem]())
        }

        private func _encode<T: Encodable>(_ value: T, forKey key: Key) throws {
            encoder.codingPath.append(key)
            defer { encoder.codingPath.removeLast() }
            let value = try encoder.box(value)
            
            func converted(_ key: CodingKey) -> CodingKey {
                switch encoder.options.keyEncodingStrategy {
                case .useDefaultKeys:
                    return key
                case .convertToSnakeCase:
                    let newKeyString = KeyEncodingStrategy.convertToSnakeCase(key.stringValue)
                    return AnyCodingKey(stringValue: newKeyString, intValue: key.intValue)
                case .custom(let converter):
                    return converter(codingPath + [key])
                }
            }

            if let values = value as? [String] {
                guard var queryItems = encoder.storage.topContainer as? [URLQueryItem] else { return }
                encoder.storage.popContainer()
                queryItems += values.map { URLQueryItem(name: converted(key).stringValue, value: $0) }
                encoder.storage.push(container: queryItems)
            } else {
                let description = "Expected to encode \(T.self) but can't default transform \([String].self)."
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(value, context)
            }
        }

        func encodeNil(forKey key: Key) throws {}
        
        func encode(_ value: Bool, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Int, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Int8, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Int16, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Int32, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Int64, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: UInt, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: UInt8, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: UInt16, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: UInt32, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: UInt64, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Float, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: Double, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode(_ value: String, forKey key: Key) throws { try _encode(value, forKey: key) }
        
        func encode<T: Encodable>(_ value: T, forKey key: Key) throws { try _encode(value, forKey: key) }

        func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            encoder.codingPath.append(key)
            defer { encoder.codingPath.removeLast() }
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(encoder: encoder))
        }

        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            encoder.codingPath.append(key)
            defer { encoder.codingPath.removeLast() }
            return UnkeyedContanier(encoder: encoder)
        }

        func superEncoder() -> Encoder { encoder }

        func superEncoder(forKey key: Key) -> Encoder { encoder }
    }
}
