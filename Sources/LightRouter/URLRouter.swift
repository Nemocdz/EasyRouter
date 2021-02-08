//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

protocol URLRouter {
    associatedtype Output
    func register(urlPattern: String, output: Output)
    func match(url: URL, parameters: inout [String: String]) -> [Output]
}
