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

    @discardableResult
    public func register(urlPattern: String, handler: LightRouterHandler) -> Bool {
        let urlComponents = urlPattern.urlComponents
        guard !urlComponents.isEmpty else { return false }
        lock.lock()
        trie.register(urlComponents: urlComponents, output: handler)
        lock.unlock()
        return true
    }

    public func route(to url: URL, completion: RouteCompletion? = nil) {
        let routeResult = routeResult(of: url)
        handleRouteResult(routeResult, completion: completion)
    }

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

    public func handleRouteResult(_ result: RouteResult, completion: RouteCompletion? = nil) {
        guard result.canHandle else {
            completion?(.failure(.mismatch))
            return
        }
        let context = result.context
        let handlers = result.handlers
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
        public let context: LightRouterHandlerContext
        let handlers: [LightRouterHandler]

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
