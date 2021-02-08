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
        public let parameters: [String: String]
    }
    
    enum HandlerResult {
        case next
        case finish
    }
}

public protocol LightRouterHandler {
    func handle(request: LightRouter.Request, completion: (LightRouter.HandlerResult) -> ())
}
