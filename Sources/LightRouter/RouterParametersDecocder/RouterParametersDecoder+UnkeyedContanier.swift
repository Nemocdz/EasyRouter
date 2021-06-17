//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

extension RouterParametersDecoder {
    struct UnkeyedContanier: UnkeyedDecodingContainer {
        let decoder: Impl
        let container: [RouterParameters.Value.Element]
        
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
}
