//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/8.
//

import XCTest
@testable import EasyRouter

final class RouterParametersDecoderTests: XCTestCase {
    func testDecodeInt() throws {
        let p1: RouterParameters = ["int": ["1", "-2"]]
        let p2: RouterParameters = ["int": ["1"]]
        let decoder = RouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let int: Int
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssertEqual(object.int, 1)
        }
        
        func testIntArray() throws {
            struct Object: Decodable {
                let int: [Int]
            }
            
            let object = try decoder.decode(Object.self, from: p1)
            XCTAssertEqual(object.int, [1, -2])
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let int: UInt
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssertEqual(object.int, 1)
        }
        
        func testUIntArray() throws {
            struct Object: Decodable {
                let int: [UInt]
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssertEqual(object.int, [1])
        }
        
        XCTAssertNoThrow(try testInt())
        XCTAssertNoThrow(try testIntArray())
        XCTAssertNoThrow(try testUInt())
        XCTAssertNoThrow(try testUIntArray())
    }
    
    
    func testDecodeString() throws {
        let p1: RouterParameters = ["string": ["a", "b"]]
        let p2: RouterParameters = ["string": ["a"]]
        let decoder = RouterParametersDecoder()
        
        func testString() throws {
            struct Object: Decodable {
                let string: String
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssertEqual(object.string, "a")
        }
        
        func testStringArray() throws {
            struct Object: Decodable {
                let string: [String]
            }
            
            let object = try decoder.decode(Object.self, from: p1)
            XCTAssertEqual(object.string, ["a", "b"])
        }
        
        XCTAssertNoThrow(try testString())
        XCTAssertNoThrow(try testStringArray())
    }

    func testDecodeBool() throws {
        let p1: RouterParameters = ["bool": ["true", "false"]]
        let p2: RouterParameters = ["bool": ["true"]]
        let decoder = RouterParametersDecoder()
        
        func testBool() throws {
            struct Object: Decodable {
                let bool: Bool
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssertEqual(object.bool, true)
        }
        
        func testBoolArray() throws {
            struct Object: Decodable {
                let bool: [Bool]
            }
            
            let object = try decoder.decode(Object.self, from: p1)
            XCTAssertEqual(object.bool, [true, false])
        }
        
        XCTAssertNoThrow(try testBool())
        XCTAssertNoThrow(try testBoolArray())
    }
    
    func testDecodeFloat() throws {
        let p1: RouterParameters = ["float": ["1.1", "-2.1"]]
        let p2: RouterParameters = ["float": ["1.1"]]
        let decoder = RouterParametersDecoder()
        
        func testDouble() throws {
            struct Object: Decodable {
                let float: Double
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssert(object.float.isEqual(to: 1.1))
        }
        
        func testDoubleArray() throws {
            struct Object: Decodable {
                let float: [Double]
            }
            
            
            let object = try decoder.decode(Object.self, from: p1)
            let result: [Double] = [1.1, -2.1]
            XCTAssertEqual(object.float.count, result.count)
            XCTAssert(zip(object.float, result).allSatisfy({ $0.isEqual(to: $1) }))
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let float: Float
            }
            
            XCTAssertThrowsError(try decoder.decode(Object.self, from: p1))
            let object = try decoder.decode(Object.self, from: p2)
            XCTAssert(object.float.isEqual(to: 1.1))
        }
        
        func testFloatArray() throws {
            struct Object: Decodable {
                let float: [Float]
            }
            
            let object = try decoder.decode(Object.self, from: p1)
            let result: [Float] = [1.1, -2.1]
            XCTAssertEqual(object.float.count, result.count)
            XCTAssert(zip(object.float, result).allSatisfy({ $0.isEqual(to: $1) }))
        }
        
        XCTAssertNoThrow(try testFloat())
        XCTAssertNoThrow(try testFloatArray())
        XCTAssertNoThrow(try testDouble())
        XCTAssertNoThrow(try testDoubleArray())
    }
    
    func testEmpty() throws {
        let parameters: RouterParameters = ["empty": []]
        let decoder = RouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let empty: Int?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testString() throws {
            struct Object: Decodable {
                let empty: String?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let empty: UInt?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testDouble() throws {
            struct Object: Decodable {
                let empty: Double?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let empty: Float?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testBool() throws {
            struct Object: Decodable {
                let empty: Bool?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
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
        let parameters: RouterParameters = [:]
        let decoder = RouterParametersDecoder()
        
        func testInt() throws {
            struct Object: Decodable {
                let empty: Int?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testString() throws {
            struct Object: Decodable {
                let empty: String?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testUInt() throws {
            struct Object: Decodable {
                let empty: UInt?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testDouble() throws {
            struct Object: Decodable {
                let empty: Double?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testFloat() throws {
            struct Object: Decodable {
                let empty: Float?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
        }
        
        func testBool() throws {
            struct Object: Decodable {
                let empty: Bool?
            }
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertNil(object.empty)
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
        let parameters: RouterParameters = [
            "snake_value": ["1"],
            "_snake_value": ["1"],
            "_snake_value_": ["1"],
            "_": ["1"],
            "_snake": ["1"],
            "snake_": ["1"],
        ]
        let decoder = RouterParametersDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        func _testSnake() throws {
            struct Object: Decodable {
                let snakeValue: Int
                let _snakeValue: Int
                let _snakeValue_: Int
                let `_`: Int
                let _snake: Int
                let snake_: Int
            }
            
            let object = try decoder.decode(Object.self, from: parameters)
            XCTAssertEqual(object.snakeValue, 1)
            XCTAssertEqual(object._snakeValue, 1)
            XCTAssertEqual(object._snakeValue_, 1)
            XCTAssertEqual(object._, 1)
            XCTAssertEqual(object._snake, 1)
            XCTAssertEqual(object.snake_, 1)
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
