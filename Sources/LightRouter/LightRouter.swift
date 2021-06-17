import Foundation

public class LightRouter {
    private let trie = TrieRouter<LightRouterHandler>()
    private let lock = NSLock()
    
    public init() {
    }

    public func register(urlPattern: String, handler: LightRouterHandler) {
        lock.lock()
        defer { lock.unlock() }
        trie.register(urlPattern: urlPattern, output: handler)
    }
    
    public func route(to url: URL, completion: (Result<LightRouterHandlerContext, Error>) -> ()) {
        let routeResult = routeResult(of: url)
        handleRouteResult(routeResult, completion: completion)
    }
    
    public func routeResult(of url: URL) -> RouteResult {
        lock.lock()
        defer { lock.unlock() }
        var parameters = RouterParameters()
        let handlers = trie.match(url: url, parameters: &parameters)
        let context = LightRouterHandlerContext(url: url, parameters: parameters)
        return RouteResult(context: context, handlers: handlers)
    }
    
    public func handleRouteResult(_ result: RouteResult, completion: (Result<LightRouterHandlerContext, Error>) -> ()) {
        guard result.canHandle else {
            return completion(.failure(.mismatch))
        }
        let context = result.context
        let handlers = result.handlers
        var handlerIndex = 0
        func handleNext() {
            guard handlerIndex < handlers.count else {
                return completion(.success(context))
            }
            let handler = handlers[handlerIndex]
            handler.handle(context: context) { result in
                context.executedHandlers.append(handler)
                switch result {
                case .finish:
                    completion(.success(context))
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
