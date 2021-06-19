//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

extension RouterParametersDecoder {
    final class Impl: Decoder {
        var storage = Storage()
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey : Any] { options.userInfo }
        let options: Options
        
        let container: RouterParameters
        
        init(container: RouterParameters, options: Options, codingPath: [CodingKey] = []) {
            storage.push(container: container)
            self.options = options
            self.codingPath = codingPath
            self.container = container
        }
        
        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            KeyedDecodingContainer(KeyedContainer<Key>(decoder: self,
                                                       container: try castOrThrow(storage.topContainer,
                                                                                  as: RouterParameters.self)))
        }
        
        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            UnkeyedContanier(decoder: self,
                             container: try castOrThrow(storage.topContainer,
                                                        as: [RouterParameters.Value.Element].self))
        }
        
        func singleValueContainer() throws -> SingleValueDecodingContainer {
            SingleValueContainer(decoder: self)
        }
    }
}

extension RouterParametersDecoder.Impl {
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
