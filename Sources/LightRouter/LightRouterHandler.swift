//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public extension LightRouter {
    struct Request {
        public let url: URL
        public let parameters: URLRouterParameters
    }
    
    enum HandlerResult {
        case next
        case finish
    }
}

public protocol LightRouterHandler {
    func handle(request: LightRouter.Request, completion: (LightRouter.HandlerResult) -> ())
}

public protocol LightRouterModelHandler: LightRouterHandler {
    associatedtype ParametersModel: Decodable
    var parametersDecoder: URLRouterParametersDecoder { get }
    func handle(request: LightRouter.Request, result: Result<ParametersModel, Error>, completion: (LightRouter.HandlerResult) -> ())
}

public extension LightRouterModelHandler {
    func handle(request: LightRouter.Request, completion: (LightRouter.HandlerResult) -> ()) {
        let result: Result<ParametersModel, Error>
        do {
            let model = try parametersDecoder.decode(ParametersModel.self, from: request.parameters)
            result = .success(model)
        } catch {
            result = .failure(error)
        }
        handle(request: request, result: result, completion: completion)
    }
    
    var parametersDecoder: URLRouterParametersDecoder {
        return .init()
    }
}


