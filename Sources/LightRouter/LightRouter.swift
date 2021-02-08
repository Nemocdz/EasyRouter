import Foundation

public class LightRouter {
    public enum RouterError: Error {
        case mismatch
        case unfinish
    }

    private let trie = TrieRouter<LightRouterHandler>()
    private let lock = NSRecursiveLock()
    
    public init() {
    }

    public func register(urlPattern: String, handler: LightRouterHandler) {
        lock.lock()
        defer { lock.unlock() }
        trie.register(urlPattern: urlPattern, output: handler)
    }
    
    public func route(to url: URL, completion: (Result<(), RouterError>) -> ()) {
        lock.lock()
        var parameters = [String: String]()
        let handlers = trie.match(url: url, parameters: &parameters)
        lock.unlock()
        
        let request = Request(url: url, parameters: parameters)
        
        guard !handlers.isEmpty else {
            return completion(.failure(.mismatch))
        }
        
        var handlerIndex = 0
        
        func handleNext() {
            guard handlerIndex < handlers.count else {
                return completion(.failure(.unfinish))
            }
            
            let handler = handlers[handlerIndex]
            handler.handle(request: request) { result in
                switch result {
                case .finish:
                    completion(.success(()))
                case .next:
                    handlerIndex += 1
                    handleNext()
                }
            }
        }
        
        handleNext()
    }
}
