//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/8.
//

import XCTest
@testable import LightRouter

final class URLRouterParametersDecoderTests: XCTestCase {
    override func setUp() {
    }
    
    func testDecodeInt() throws {
        let parameters: URLRouterParameters = ["int": ["1", "-2"]]
        let decoder = URLRouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let int: Int
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.int == 1)
        }
        
        func testIntArray() throws {
            struct Object: Decodable {
                let int: [Int]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.int == [1, -2])
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let int: UInt
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.int == 1)
        }
        
        func testUIntArray() throws {
            struct Object: Decodable {
                let int: [UInt]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.int == [1, 2])
        }
        
        XCTAssertNoThrow(try testInt())
        XCTAssertNoThrow(try testIntArray())
        XCTAssertNoThrow(try testUInt())
        XCTAssertThrowsError(try testUIntArray())
    }
    
    
    func testDecodeString() throws {
        let parameters: URLRouterParameters = ["string": ["a", "b"]]
        let decoder = URLRouterParametersDecoder()
        
        func testString() throws {
            struct Object: Decodable {
                let string: String
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.string == "a")
        }
        
        func testStringArray() throws {
            struct Object: Decodable {
                let string: [String]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.string == ["a", "b"])
        }
        
        XCTAssertNoThrow(try testString())
        XCTAssertNoThrow(try testStringArray())
    }

    func testDecodeBool() throws {
        let parameters: URLRouterParameters = ["bool": ["true", "false"]]
        let decoder = URLRouterParametersDecoder()
        
        func testBool() throws {
            struct Object: Decodable {
                let bool: Bool
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.bool == true)
        }
        
        func testBoolArray() throws {
            struct Object: Decodable {
                let bool: [Bool]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.bool == [true, false])
        }
        
        XCTAssertNoThrow(try testBool())
        XCTAssertNoThrow(try testBoolArray())
    }
    
    func testDecodeFloat() throws {
        let parameters: URLRouterParameters = ["float": ["1.1", "-2.1"]]
        let decoder = URLRouterParametersDecoder()
        
        func testDouble() throws {
            struct Object: Decodable {
                let float: Double
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.float.isEqual(to: 1.1))
        }
        
        func testDoubleArray() throws {
            struct Object: Decodable {
                let float: [Double]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(zip(object.float, [1.1, -2.1]).allSatisfy({ $0.isEqual(to: $1) }))
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let float: Float
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.float.isEqual(to: 1.1))
        }
        
        func testFloatArray() throws {
            struct Object: Decodable {
                let float: [Float]
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(zip(object.float, [1.1, -2.1]).allSatisfy({ $0.isEqual(to: $1) }))
        }
        
        XCTAssertNoThrow(try testFloat())
        XCTAssertNoThrow(try testFloatArray())
        XCTAssertNoThrow(try testDouble())
        XCTAssertNoThrow(try testDoubleArray())
    }
    
    func testEmpty() throws {
        let parameters: URLRouterParameters = ["empty": []]
        let decoder = URLRouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let empty: Int?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testString() throws {
            struct Object: Decodable {
                let empty: String?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let empty: UInt?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testDouble() throws {
            struct Object: Decodable {
                let empty: Double?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let empty: Float?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testBool() throws {
            struct Object: Decodable {
                let empty: Bool?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testIntArray() throws {
            struct Object: Decodable {
                let empty: [Int]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testStringArray() throws {
            struct Object: Decodable {
                let empty: [String]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testUIntArray() throws {
            struct Object: Decodable {
                let empty: [UInt]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testDoubleArray() throws {
            struct Object: Decodable {
                let empty: [Double]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testFloatArray() throws {
            struct Object: Decodable {
                let empty: [Float]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testBoolArray() throws {
            struct Object: Decodable {
                let empty: [Bool]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        XCTAssertNoThrow(try testInt())
        XCTAssertNoThrow(try testUInt())
        XCTAssertNoThrow(try testString())
        XCTAssertNoThrow(try testDouble())
        XCTAssertNoThrow(try testFloat())
        XCTAssertNoThrow(try testBool())
        XCTAssertNoThrow(try testIntArray())
        XCTAssertNoThrow(try testUIntArray())
        XCTAssertNoThrow(try testStringArray())
        XCTAssertNoThrow(try testDoubleArray())
        XCTAssertNoThrow(try testFloatArray())
        XCTAssertNoThrow(try testBoolArray())
    }
    
    func testOptional() throws {
        let parameters: URLRouterParameters = [:]
        let decoder = URLRouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let empty: Int?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testString() throws {
            struct Object: Decodable {
                let empty: String?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let empty: UInt?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testDouble() throws {
            struct Object: Decodable {
                let empty: Double?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let empty: Float?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testBool() throws {
            struct Object: Decodable {
                let empty: Bool?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty == nil)
        }
        
        func testIntArray() throws {
            struct Object: Decodable {
                let empty: [Int]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testStringArray() throws {
            struct Object: Decodable {
                let empty: [String]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testUIntArray() throws {
            struct Object: Decodable {
                let empty: [UInt]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testDoubleArray() throws {
            struct Object: Decodable {
                let empty: [Double]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testFloatArray() throws {
            struct Object: Decodable {
                let empty: [Float]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        func testBoolArray() throws {
            struct Object: Decodable {
                let empty: [Bool]
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.empty.isEmpty)
        }
        
        XCTAssertNoThrow(try testInt())
        XCTAssertNoThrow(try testUInt())
        XCTAssertNoThrow(try testString())
        XCTAssertNoThrow(try testDouble())
        XCTAssertNoThrow(try testFloat())
        XCTAssertNoThrow(try testBool())
        XCTAssertNoThrow(try testIntArray())
        XCTAssertNoThrow(try testUIntArray())
        XCTAssertNoThrow(try testStringArray())
        XCTAssertNoThrow(try testDoubleArray())
        XCTAssertNoThrow(try testFloatArray())
        XCTAssertNoThrow(try testBoolArray())
    }
    
    func testSnake() throws {
        let parameters: URLRouterParameters = ["snake_value": ["1"], "_snake_value": ["1"], "_snake_value_": ["1"]]
        let decoder = URLRouterParametersDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        func _testSnake() throws {
            struct Object: Decodable {
                let snakeValue: Int
                let _snakeValue: Int
                let _snakeValue_: Int
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssert(object.snakeValue == 1)
            XCTAssert(object._snakeValue == 1)
            XCTAssert(object._snakeValue_ == 1)
        }
        
        XCTAssertNoThrow(try _testSnake())
    }
    

    static var allTests = [
        ("testDecodeInt", testDecodeInt),
        ("testDecodeString", testDecodeString),
        ("testDecodeBool", testDecodeBool),
        ("testDecodeFloat", testDecodeFloat),
        ("testEmpty", testEmpty),
        ("testOptional", testOptional),
        ("testSnake", testSnake),
    ]
}
