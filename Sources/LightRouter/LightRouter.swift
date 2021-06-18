//
//  File.swift
//
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public class LightRouter {
    public typealias RouteCompletion = (Result<LightRouterHandlerContext, Error>) -> Void

    private let trie = TrieRouter<LightRouterHandler>()
    private let lock = NSLock()

    public init() {}

    
    /// 注册匹配模式字符串和对应的执行结果
    /// - Parameters:
    ///   - urlPattern: 匹配模式字符串
    ///   - handler: 中间件
    /// - Returns: 是否注册成功，如果非法字符串则失败
    @discardableResult
    public func register(urlPattern: String, handler: LightRouterHandler) -> Bool {
        let urlComponents = urlPattern.urlComponents
        guard !urlComponents.isEmpty else { return false }
        lock.lock()
        trie.register(urlComponents: urlComponents, output: handler)
        lock.unlock()
        return true
    }
    
    /// 获取 url 匹配结果，并执行匹配结果
    /// - Parameters:
    ///   - url: url
    ///   - completion: 执行结束
    public func route(to url: URL, completion: RouteCompletion? = nil) {
        let routeResult = routeResult(of: url)
        handleRouteResult(routeResult, completion: completion)
    }

    /// 获取 url 匹配结果
    /// - Parameter url: url
    /// - Returns: 匹配结果
    public func routeResult(of url: URL) -> RouteResult {
        var parameters = RouterParameters()
        lock.lock()
        let handlers = trie.match(urlComponents: url.urlComponents, parameters: &parameters)
        lock.unlock()
        url.queryItems.forEach {
            if let value = $0.value {
                parameters.addValue(value, forKey: $0.name)
            }
        }
        let context = LightRouterHandlerContext(url: url, parameters: parameters)
        return RouteResult(context: context, handlers: handlers)
    }

    /// 执行匹配结果
    /// - Parameters:
    ///   - result: 匹配结果
    ///   - reversed: 执行顺序是否倒序（默认是路径短的结果先执行，通用的匹配结果比精确的结果先执行）
    ///   - completion: 执行结束
    public func handleRouteResult(_ result: RouteResult, reversed: Bool = false, completion: RouteCompletion? = nil) {
        guard result.canHandle else {
            completion?(.failure(.mismatch))
            return
        }
        let context = result.context
        let handlers = reversed ? result.handlers.reversed() : result.handlers
        var handlerIndex = 0
        func handleNext() {
            guard handlerIndex < handlers.count else {
                completion?(.success(context))
                return
            }
            let handler = handlers[handlerIndex]
            handler.handle(context: context) { result in
                context.executedHandlers.append(handler)
                switch result {
                case .finish:
                    completion?(.success(context))
                case .next:
                    handlerIndex += 1
                    handleNext()
                }
            }
        }
        handleNext()
    }
}

public extension LightRouter {
    struct RouteResult {
        /// 处理过程上下文
        public let context: LightRouterHandlerContext
        
        /// 所有匹配到的中间件
        public let handlers: [LightRouterHandler]

        /// 是否可有匹配结果可以处理
        public var canHandle: Bool {
            !handlers.isEmpty
        }
    }
}

public extension LightRouter {
    enum Error: Swift.Error {
        case mismatch
    }
}
