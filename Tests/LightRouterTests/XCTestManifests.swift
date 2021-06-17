import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TrieRouterTests.allTests),
        testCast(RouterParametersDecoderTests.allTests),
    ]
}
#endif
