//
//  File.swift
//  
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public typealias EasyRouterHandlerCompletion = (EasyRouterHandlerResult) -> Void

public protocol EasyRouterHandler {
    associatedtype Parameters: Decodable
    
    /// 参数解码器
    var parametersDecoder: RouterParametersDecoder { get }
    
    /// 中间件执行函数
    /// - Parameters:
    ///   - context: 上下文
    ///   - result: 参数模型结果
    ///   - completion: 执行结束结果
    func handle(context: EasyRouterHandlerContext, result: Result<Parameters, Error>, completion: @escaping EasyRouterHandlerCompletion)
}

extension EasyRouterHandler {
    func handle(context: EasyRouterHandlerContext, completion: @escaping EasyRouterHandlerCompletion) {
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
