//
//  File.swift
//  
//
//  Created by Nemo on 2021/12/15.
//

import Foundation

class URLRouterBoxBase<T>: URLRouter {
    func register(components: [String], output: T) {
        fatalError()
    }
    
    func match(components: [String], parameters: inout RouterParameters) -> [T] {
        fatalError()
    }
}

final class URLRouterBox<Base: URLRouter>: URLRouterBoxBase<Base.Output> {
    private var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    override func register(components: [String], output: Base.Output) {
        base.register(components: components, output: output)
    }
    
    override func match(components: [String], parameters: inout RouterParameters) -> [Base.Output] {
        base.match(components: components, parameters: &parameters)
    }
}

struct AnyURLRouter<T>: URLRouter {
    private var box: URLRouterBoxBase<T>
    
    init<Base>(_ base: Base) where Base: URLRouter, Base.Output == T {
        box = URLRouterBox(base)
    }
    
    func register(components: [String], output: T) {
        box.register(components: components, output: output)
    }
    
    func match(components: [String], parameters: inout RouterParameters) -> [T] {
        box.match(components: components, parameters: &parameters)
    }
}
