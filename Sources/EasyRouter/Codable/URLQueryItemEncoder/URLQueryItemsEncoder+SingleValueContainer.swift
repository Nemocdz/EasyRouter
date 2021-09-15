//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import Foundation

extension URLQueryItemsEncoder {
    struct SingleValueContainer: SingleValueEncodingContainer {
        let encoder: Impl
        
        var codingPath: [CodingKey] { encoder.codingPath }
        
        private func _encode(_ value: Any) {
            let value: String = "\(value)"
            encoder.storage.push(container: [value])
        }
        
        mutating func encodeNil() throws { }
        
        mutating func encode(_ value: Bool) throws { _encode(value) }
        
        mutating func encode(_ value: String) throws { _encode(value) }
        
        mutating func encode(_ value: Double) throws { _encode(value) }
        
        mutating func encode(_ value: Float) throws { _encode(value) }
        
        mutating func encode(_ value: Int) throws { _encode(value) }
        
        mutating func encode(_ value: Int8) throws { _encode(value) }
        
        mutating func encode(_ value: Int16) throws { _encode(value) }
        
        mutating func encode(_ value: Int32) throws { _encode(value) }
        
        mutating func encode(_ value: Int64) throws { _encode(value) }
        
        mutating func encode(_ value: UInt) throws { _encode(value) }
        
        mutating func encode(_ value: UInt8) throws { _encode(value) }
        
        mutating func encode(_ value: UInt16) throws { _encode(value) }
        
        mutating func encode(_ value: UInt32) throws { _encode(value) }
        
        mutating func encode(_ value: UInt64) throws { _encode(value) }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            let description = "Expected to encode \(T.self) but can't default transform to \(String.self)."
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: description, underlyingError: nil)
            throw EncodingError.invalidValue(value, context)
        }
    }
}
