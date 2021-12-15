//
//  File.swift
//
//
//  Created by Nemo on 2020/11/20.
//

import Foundation

public class EasyRouter {
    public typealias RouteCompletion = (Result<EasyRouterHandlerContext, Never>) -> Void

    private let lock = NSLock()
    private let routerImp: AnyURLRouter<EasyRouterHandler>

    public required init<T>(routerImp: T) where T: URLRouter, T.Output == EasyRouterHandler {
        self.routerImp = AnyURLRouter(routerImp)
    }

    public convenience init() {
        self.init(routerImp: TrieRouter<EasyRouterHandler>())
    }
    
    /// 注册匹配模式字符串和对应的执行结果
    /// - Parameters:
    ///   - urlPattern: 匹配模式字符串
    ///   - handler: 中间件
    /// - Returns: 是否注册成功，如果非法字符串则失败
    @discardableResult
    public func register(urlPattern: String, handler: EasyRouterHandler) -> Bool {
        let components = urlPattern.urlComponents.map { RouterPathComponent(stringLiteral: $0) }
        guard !components.isEmpty else { return false }
        lock.lock()
        routerImp.register(pathComponents: components, output: handler)
        lock.unlock()
        return true
    }
    
    /// 获取 url 匹配结果，并执行匹配结果
    /// - Parameters:
    ///   - url: url
    ///   - completion: 执行结束
    public func route(to url: URL, completion: RouteCompletion? = nil) {
        routeResult(of: url).handle(completion: completion)
    }

    /// 获取 url 匹配结果
    /// - Parameter url: url
    /// - Returns: 匹配结果
    public func routeResult(of url: URL) -> RouteResult {
        var parameters = RouterParameters()
        lock.lock()
        let handlers = routerImp.match(components: url.urlComponents, parameters: &parameters)
        lock.unlock()
        url.queryItems.forEach {
            if let value = $0.value {
                parameters.addValue(value, forKey: $0.name)
            }
        }
        let context = EasyRouterHandlerContext(url: url, parameters: parameters)
        return RouteResult(context: context, handlers: handlers)
    }
}

public extension EasyRouter {
    struct RouteResult {
        /// 处理过程上下文
        public let context: EasyRouterHandlerContext
        
        /// 所有匹配到的中间件
        public let handlers: [EasyRouterHandler]
        
        /// 执行匹配结果
        /// - Parameters:
        ///   - reversed: 执行顺序是否倒序（默认是路径短的结果先执行，通用的匹配结果比精确的结果先执行）
        ///   - completion: 执行结束
        public func handle(reversed: Bool = false, completion: RouteCompletion? = nil) {
            guard !handlers.isEmpty else {
                completion?(.success(context))
                return
            }
            let handlers = reversed ? handlers.reversed() : handlers
            var handlerIndex = 0
            func handleNext() {
                guard handlerIndex < handlers.count else {
                    completion?(.success(context))
                    return
                }
                let handler = handlers[handlerIndex]
                handler.handle(context: context) {
                    context.executedHandlers.append(handler)
                    switch $0 {
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
}
