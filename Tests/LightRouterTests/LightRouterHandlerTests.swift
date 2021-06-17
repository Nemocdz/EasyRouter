//
//  File.swift
//
//
//  Created by Nemo on 2021/6/18.
//

@testable import LightRouter
import XCTest

final class LightRouterHandlerTests: XCTestCase {
    struct NextHandler: LightRouterHandler {
        let exp: XCTestExpectation
        func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> Void) {
            exp.fulfill()
            completion(.next)
        }
    }
    
    struct FinishHandler: LightRouterHandler {
        let exp: XCTestExpectation
        func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> Void) {
            exp.fulfill()
            completion(.finish)
        }
    }
    
    func testNextHandle() {
        let next = expectation(description: "next")
        let completion = expectation(description: "completion")
        
        let router = LightRouter()
        router.register(urlPattern: "a://**", handler: NextHandler(exp: next))
        router.route(to: "a://b") { result in
            completion.fulfill()
            XCTAssertNotNil(try? result.get())
        }
        
        wait(for: [next, completion], timeout: 1, enforceOrder: true)
    }
    
    func testFinishHandle() {
        let next = expectation(description: "next")
        next.isInverted = true
        let finish = expectation(description: "finish")
        let completion = expectation(description: "completion")
        
        let router = LightRouter()
        router.register(urlPattern: "a://b", handler: NextHandler(exp: next))
        router.register(urlPattern: "a://**", handler: FinishHandler(exp: finish))
        
        let result = router.routeResult(of: "a://b")
        
        XCTAssert(result.handlers.count == 2)
        
        router.handleRouteResult(result) { result in
            completion.fulfill()
            XCTAssertNotNil(try? result.get())
        }
        
        wait(for: [next, finish, completion], timeout: 1, enforceOrder: true)
    }
    
    func testMismatch() {
        let completion = expectation(description: "completion")
        let router = LightRouter()
        
        let result = router.routeResult(of: "a://b")
        
        XCTAssert(!result.canHandle)
        
        router.handleRouteResult(result) { result in
            completion.fulfill()
            switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    XCTAssert(error == .mismatch)
            }
        }
    
        wait(for: [completion], timeout: 1)
    }
    
    func testContext() {
        let next1 = expectation(description: "next")
        let next2 = expectation(description: "finish")
        let completion = expectation(description: "completion")
        
        struct Next1Handler: LightRouterHandler {
            let exp: XCTestExpectation
            func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> Void) {
                XCTAssert(context.executedHandlers.isEmpty)
                XCTAssert(context.userInfo.keys.contains(0))
                context.userInfo[1] = true
                exp.fulfill()
                completion(.next)
            }
        }
        
        struct Next2Handler: LightRouterHandler {
            let exp: XCTestExpectation
            func handle(context: LightRouterHandlerContext, completion: (LightRouterHandlerResult) -> Void) {
                XCTAssert(context.executedHandlers.count == 1)
                XCTAssert(context.userInfo.keys.contains(0))
                XCTAssert(context.userInfo.keys.contains(1))
                context.userInfo[2] = true
                exp.fulfill()
                completion(.next)
            }
        }
        
        let router = LightRouter()
        router.register(urlPattern: "a://**", handler: Next1Handler(exp: next1))
        router.register(urlPattern: "a://b", handler: Next2Handler(exp: next2))
        
        let result = router.routeResult(of: "a://b")
        XCTAssert(result.handlers.count == 2)
        XCTAssert(result.context.executedHandlers.isEmpty)
        result.context.userInfo[0] = true
        
        router.handleRouteResult(result) { result in
            completion.fulfill()
            switch result {
                case .success(let context):
                    XCTAssert(context.executedHandlers.count == 2)
                    XCTAssert(context.userInfo.keys.contains(0))
                    XCTAssert(context.userInfo.keys.contains(1))
                    XCTAssert(context.userInfo.keys.contains(2))
                case .failure:
                    XCTFail()
            }
        }
        
        wait(for: [next1, next2, completion], timeout: 1, enforceOrder: true)
    }
    
    func testModelHandler() {
        let next = expectation(description: "next")
        let completion = expectation(description: "completion")
        
        struct ModelHandler: LightRouterModelHandler {
            struct Parameters: Decodable {
                let name: String
                let age: Int
            }
            
            let exp: XCTestExpectation
            
            func handle(context: LightRouterHandlerContext, result: Result<Parameters, Error>, completion: (LightRouterHandlerResult) -> Void) {
                XCTAssertNotNil(try? result.get())
                exp.fulfill()
                completion(.next)
            }
        }
        
        let router = LightRouter()
        router.register(urlPattern: "a://**", handler: ModelHandler(exp: next))
        router.route(to: "a://b?name=hello&age=2") { result in
            completion.fulfill()
            XCTAssertNotNil(try? result.get())
        }
        
        wait(for: [next, completion], timeout: 1, enforceOrder: true)
    }
    
    static var allTests = [
        ("testNextHandle", testNextHandle),
        ("testFinishHandle", testFinishHandle),
        ("testMismatch", testMismatch),
        ("testContext", testContext),
        ("testModelHandler", testModelHandler),
    ]
}
    
