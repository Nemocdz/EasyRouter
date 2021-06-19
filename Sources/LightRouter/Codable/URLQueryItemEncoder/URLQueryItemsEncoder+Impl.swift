//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import Foundation

extension URLQueryItemsEncoder {
    final class Impl: Encoder {
        var codingPath: [CodingKey] = []
        var userInfo: [CodingUserInfoKey : Any] { options.userInfo }
        
        var storage = Storage()
        let options: Options
        
        init(options: Options) {
            self.options = options
        }
        
        func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
            KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            UnkeyedContanier(encoder: self)
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            SingleValueContainer(encoder: self)
        }
    }
}

extension URLQueryItemsEncoder.Impl {
    func box<T: Encodable>(_ value: T) throws -> Any {
        try value.encode(to: self)
        let value = storage.topContainer
        storage.popContainer()
        return value
    }
}
