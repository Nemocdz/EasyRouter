//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

public typealias RouterParameters = [String: [String]]

protocol URLRouter {
    associatedtype Output
    mutating func register(urlComponents: [String], output: Output)
    func match(urlComponents: [String], parameters: inout RouterParameters) -> [Output]
}
