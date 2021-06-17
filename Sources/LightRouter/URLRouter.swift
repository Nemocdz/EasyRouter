//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/19.
//

import Foundation

public typealias URLRouterParameters = [String: [String]]

protocol URLRouter {
    associatedtype Output
    func register(urlPattern: String, output: Output)
    func match(url: URL, parameters: inout URLRouterParameters) -> [Output]
}
