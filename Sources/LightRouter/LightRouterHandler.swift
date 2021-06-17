//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public protocol LightRouterHandler {
    func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> ())
}

public protocol LightRouterModelHandler: LightRouterHandler {
    associatedtype ParametersModel: Decodable
    var parametersDecoder: RouterParametersDecoder { get }
    func handle(context: LightRouterHandlerContext, result: Result<ParametersModel, Error>, completion: (LightRouterHandlerResult) -> ())
}

public extension LightRouterModelHandler {
    func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> ()) {
        let result: Result<ParametersModel, Error>
        do {
            let model = try parametersDecoder.decode(ParametersModel.self, from: context.parameters)
            result = .success(model)
        } catch {
            result = .failure(error)
        }
        handle(context: context, result: result, completion: completion)
    }
    
    var parametersDecoder: RouterParametersDecoder {
        return .init()
    }
}


