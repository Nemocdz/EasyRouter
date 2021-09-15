//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

public final class EasyRouterHandlerContext {
    
    /// 原始 url
    public let url: URL
    
    /// 匹配出的参数
    public let parameters: RouterParameters
    
    /// 已经执行的中间件
    public internal(set) var executedHandlers: [EasyRouterHandler] = []
    
    /// 自定义的信息
    public var userInfo: [AnyHashable: Any] = [:]
    
    init(url: URL, parameters: RouterParameters) {
        self.url = url
        self.parameters = parameters
    }
}
