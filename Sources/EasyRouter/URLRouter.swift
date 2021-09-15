//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

protocol URLRouter {
    associatedtype Output
    mutating func register(components: [RouterComponent], output: Output)
    func match(urlComponents: [String], parameters: inout RouterParameters) -> [Output]
}
