//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

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
    
    static let `super` = AnyCodingKey(stringValue: "super", intValue: nil)
}
