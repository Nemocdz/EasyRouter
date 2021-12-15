//
//  File.swift
//  
//
//  Created by Nemo on 2021/12/15.
//

import Foundation

class URLRouterBox<T>: URLRouter {
    func register(pathComponents: [RouterPathComponent], output: T) {
        fatalError()
    }
    
    func match(components: [String], parameters: inout RouterParameters) -> [T] {
        fatalError()
    }
}

final class URLRouterBoxImp<Base: URLRouter>: URLRouterBox<Base.Output>  {
    private var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    override func register(pathComponents: [RouterPathComponent], output: Base.Output) {
        base.register(pathComponents: pathComponents, output: output)
    }
    
    override func match(components: [String], parameters: inout RouterParameters) -> [Base.Output] {
        base.match(components: components, parameters: &parameters)
    }
}

struct AnyURLRouter<T>: URLRouter {
    private let box: URLRouterBox<T>
    
    init<Base>(_ base: Base) where Base: URLRouter, Base.Output == T {
        box = URLRouterBoxImp(base)
    }
    
    func register(pathComponents: [RouterPathComponent], output: T) {
        box.register(pathComponents: pathComponents, output: output)
    }
    
    func match(components: [String], parameters: inout RouterParameters) -> [T] {
        box.match(components: components, parameters: &parameters)
    }
}
