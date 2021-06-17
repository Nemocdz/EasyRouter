import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LightRouterTests.allTests),
        testCast(URLRouterParametersDecoderTests.allTests),
    ]
}
#endif
