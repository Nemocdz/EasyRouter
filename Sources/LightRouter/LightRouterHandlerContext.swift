//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

public final class LightRouterHandlerContext {
    public let url: URL
    public let parameters: RouterParameters
    public internal(set) var executedHandlers: [LightRouterHandler] = []
    public var userInfo: [AnyHashable: Any] = [:]
    
    init(url: URL, parameters: RouterParameters) {
        self.url = url
        self.parameters = parameters
    }
}
