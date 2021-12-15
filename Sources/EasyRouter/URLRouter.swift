//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

public typealias RouterParameters = [String: [String]]

public protocol URLRouter {
    associatedtype Output
    mutating func register(pathComponents: [RouterPathComponent], output: Output)
    func match(components: [String], parameters: inout RouterParameters) -> [Output]
}
