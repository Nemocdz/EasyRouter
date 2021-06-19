//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import Foundation

extension URLQueryItemsEncoder {
    struct UnkeyedContanier: UnkeyedEncodingContainer {
        let encoder: Impl
        
        var codingPath: [CodingKey] { encoder.codingPath }
    
        var count: Int { (encoder.storage.topContainer as? [Any])?.count ?? 0 }

        init(encoder: Impl) {
            self.encoder = encoder
            encoder.storage.push(container: [String]())
        }

        private func push<T: Encodable>(_ value: T) throws {
            encoder.codingPath.append(AnyCodingKey(index: count))
            defer { encoder.codingPath.removeLast() }
            let value = try encoder.box(value)
            if let values = value as? [String] {
                guard var array = encoder.storage.topContainer as? [String] else { return }
                encoder.storage.popContainer()
                array += values
                encoder.storage.push(container: array)
            } else {
                let description = "Expected to encode \(T.self) but can't default transform to \(String.self)."
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(value, context)
            }
        }

        mutating func encodeNil() throws {}
        
        mutating func encode(_ value: Bool) throws { try push(value) }
        
        mutating func encode(_ value: Int) throws { try push(value) }
        
        mutating func encode(_ value: Int8) throws { try push(value) }
        
        mutating func encode(_ value: Int16) throws { try push(value) }
        
        mutating func encode(_ value: Int32) throws { try push(value) }
        
        mutating func encode(_ value: Int64) throws { try push(value) }
        
        mutating func encode(_ value: UInt) throws { try push(value) }
        
        mutating func encode(_ value: UInt8) throws { try push(value) }
        
        mutating func encode(_ value: UInt16) throws { try push(value) }
        
        mutating func encode(_ value: UInt32) throws { try push(value) }
        
        mutating func encode(_ value: UInt64) throws { try push(value) }
        
        mutating func encode(_ value: Float) throws { try push(value) }
        
        mutating func encode(_ value: Double) throws { try push(value) }
        
        mutating func encode(_ value: String) throws { try push(value) }
        
        mutating func encode<T: Encodable>(_ value: T) throws { try push(value) }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            encoder.codingPath.append(AnyCodingKey(index: count))
            defer { encoder.codingPath.removeLast() }
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(encoder: encoder))
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            encoder.codingPath.append(AnyCodingKey(index: count))
            defer { encoder.codingPath.removeLast() }
            return UnkeyedContanier(encoder: encoder)
        }

        func superEncoder() -> Encoder { encoder }
    }
}
