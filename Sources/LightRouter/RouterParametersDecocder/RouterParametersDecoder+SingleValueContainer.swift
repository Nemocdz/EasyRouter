//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

extension RouterParametersDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let decoder: Impl
        
        var codingPath: [CodingKey] { decoder.codingPath }
        
        private func currentValue() throws -> String {
            return try decoder.castOrThrow(decoder.storage.topContainer, as: String.self)
        }
        
        private func typeError<T>(of type: T.Type) -> Error {
            let description = "Expected to decode \(type) but can't use \(String.self) to init."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            return DecodingError.typeMismatch(type, context)
        }
        
        func decodeNil() -> Bool {
            return decoder.storage.count == 0
        }
    
        func decode(_ type: Bool.Type) throws -> Bool {
            let value = try currentValue()
            if let value = Bool(value) {
                return value
            } else {
                throw typeError(of: type)
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
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            let value = try currentValue()
            if let value = Float(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            let value = try currentValue()
            if let value = Int(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            let value = try currentValue()
            if let value = Int8(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            let value = try currentValue()
            if let value = Int16(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            let value = try currentValue()
            if let value = Int32(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            let value = try currentValue()
            if let value = Int64(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            let value = try currentValue()
            if let value = UInt(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            let value = try currentValue()
            if let value = UInt8(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            let value = try currentValue()
            if let value = UInt16(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            let value = try currentValue()
            if let value = UInt32(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            let value = try currentValue()
            if let value = UInt64(value) {
                return value
            } else {
                throw typeError(of: type)
            }
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let value = try currentValue()
            return try decoder.unbox(value, as: type)
        }
    }
}
