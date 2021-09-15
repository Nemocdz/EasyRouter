import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TrieRouterTests.allTests),
        testCase(RouterParametersDecoderTests.allTests),
        testCase(EasyRouterHandlerTests.allTests),
        testCase(URLQueryItemsEncoderTests.allTests),
    ]
}
#endif
