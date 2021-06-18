//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public typealias LightRouterHandlerCompletion = (LightRouterHandlerResult) -> Void

public protocol LightRouterHandler {
    
    /// 中间件执行函数
    /// - Parameters:
    ///   - context: 上下文
    ///   - completion: 执行结束结果
    func handle(context: LightRouterHandlerContext, completion: @escaping LightRouterHandlerCompletion)
}

public protocol LightRouterModelHandler: LightRouterHandler {
    associatedtype Parameters: Decodable
    
    /// 参数解码器
    var parametersDecoder: RouterParametersDecoder { get }
    
    /// 中间件执行函数
    /// - Parameters:
    ///   - context: 上下文
    ///   - result: 参数模型结果
    ///   - completion: 执行结束结果
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
