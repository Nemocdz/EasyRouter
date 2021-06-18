//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public typealias LightRouterHandlerCompletion = (LightRouterHandlerResult) -> Void

public protocol LightRouterHandler {
    func handle(context: LightRouterHandlerContext, completion: @escaping LightRouterHandlerCompletion)
}

public protocol LightRouterModelHandler: LightRouterHandler {
    associatedtype Parameters: Decodable
    var parametersDecoder: RouterParametersDecoder { get }
    func handle(context: LightRouterHandlerContext, result: Result<Parameters, Error>, completion: @escaping LightRouterHandlerCompletion)
}

public extension LightRouterModelHandler {
    func handle(context: LightRouterHandlerContext, completion: @escaping LightRouterHandlerCompletion) {
        let result: Result<Parameters, Error>
        do {
            let model = try parametersDecoder.decode(Parameters.self, from: context.parameters)
            result = .success(model)
        } catch {
            result = .failure(error)
        }
        handle(context: context, result: result, completion: completion)
    }
    
    var parametersDecoder: RouterParametersDecoder { .init() }
}
