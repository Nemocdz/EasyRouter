//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/19.
//

import XCTest
@testable import EasyRouter

final class URLQueryItemsEncoderTests: XCTestCase {
    func testEncodeInt() throws {
        let encoder = URLQueryItemsEncoder()
        
        func testInt() throws {
            struct Object: Encodable {
                let int: Int = 1
            }
        
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("int", "1")].queryItems)
        }
        
        func testIntArray() throws {
            struct Object: Encodable {
                let int: [Int] = [1, -2]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("int", "1"), ("int", "-2")].queryItems)
        }
        
       
        func testUInt() throws {
            struct Object: Encodable {
                let int: UInt = 1
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("int", "1")].queryItems)
        }
        
        func testUIntArray() throws {
            struct Object: Encodable {
                let int: [UInt] = [1, 2]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("int", "1"), ("int", "2")].queryItems)
        }
        
        XCTAssertNoThrow(try testInt())
        XCTAssertNoThrow(try testIntArray())
        XCTAssertNoThrow(try testUInt())
        XCTAssertNoThrow(try testUIntArray())
    }
    
    func testEncodeString() throws {
        let encoder = URLQueryItemsEncoder()
        
        func testString() throws {
            struct Object: Encodable {
                let string: String = "a"
            }
        
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("string", "a")].queryItems)
        }
        
        func testStringArray() throws {
            struct Object: Encodable {
                let string: [String] = ["a", "b"]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("string", "a"), ("string", "b")].queryItems)
        }
        
        XCTAssertNoThrow(try testString())
        XCTAssertNoThrow(try testStringArray())
    }
    
    func testEncodeBool() throws {
        let encoder = URLQueryItemsEncoder()
        
        func testBool() throws {
            struct Object: Encodable {
                let bool: Bool = true
            }
        
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("bool", "true")].queryItems)
        }
        
        func testBoolArray() throws {
            struct Object: Encodable {
                let bool: [Bool] = [true, false]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("bool", "true"), ("bool", "false")].queryItems)
        }
        
        XCTAssertNoThrow(try testBool())
        XCTAssertNoThrow(try testBoolArray())
    }
    
    
    func testEncodeFloat() throws {
        let encoder = URLQueryItemsEncoder()
        
        func testFloat() throws {
            struct Object: Encodable {
                let float: Float = 1.1
            }
        
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("float", "1.1")].queryItems)
        }
        
        func testFloatArray() throws {
            struct Object: Encodable {
                let float: [Float] = [1.1, -2.1]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("float", "1.1"), ("float", "-2.1")].queryItems)
        }
        
       
        func testDouble() throws {
            struct Object: Encodable {
                let double: Double = 1.1
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("double", "1.1")].queryItems)
        }
        
        func testDoubleArray() throws {
            struct Object: Encodable {
                let double: [Double] = [1.1, -2.1]
            }
            
            let queryItems = try encoder.encode(Object())
            XCTAssertEqual(queryItems, [("double", "1.1"), ("double", "-2.1")].queryItems)
        }
        
        XCTAssertNoThrow(try testFloat())
        XCTAssertNoThrow(try testFloatArray())
        XCTAssertNoThrow(try testDouble())
        XCTAssertNoThrow(try testDoubleArray())
    }

    func testEmpty() throws {
        let encoder = URLQueryItemsEncoder()
        
        func testInt() throws {
            struct Object: Encodable {
                var empty: Int? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testString() throws {
            struct Object: Encodable {
                var empty: String? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testUInt() throws {
            struct Object: Encodable {
                var empty: UInt? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testDouble() throws {
            struct Object: Encodable {
                var empty: Double? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testFloat() throws {
            struct Object: Encodable {
                var empty: Float? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testBool() throws {
            struct Object: Encodable {
                var empty: Bool? = nil
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testIntArray() throws {
            struct Object: Encodable {
                var empty: [Int] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testStringArray() throws {
            struct Object: Encodable {
                var empty: [String] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testUIntArray() throws {
            struct Object: Encodable {
                var empty: [UInt] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testDoubleArray() throws {
            struct Object: Encodable {
                var empty: [Double] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testFloatArray() throws {
            struct Object: Encodable {
                var empty: [Float] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
        }

        func testBoolArray() throws {
            struct Object: Encodable {
                var empty: [Bool] = []
            }
            let queryItems = try encoder.encode(Object())
            XCTAssert(queryItems.isEmpty)
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
        let encoder = URLQueryItemsEncoder()
        encoder.keyDecodingStrategy = .convertToSnakeCase

        func _testSnake() throws {
            struct Object: Encodable {
                let snakeValue: Int = 1
                let _snakeValue: Int = 1
                let _snakeValue_: Int = 1
                let `_`: Int = 1
                let _snake: Int = 1
                let snake_: Int = 1
            }
            
            let queryItemNames = try encoder.encode(Object()).map { $0.name }
            let keys = ["snake_value", "_snake_value", "_snake_value_", "_", "_snake", "snake_"]
            XCTAssertEqual(queryItemNames, keys)
        }

        XCTAssertNoThrow(try _testSnake())
    }

    static var allTests = [
        ("testEncodeInt", testEncodeInt),
        ("testEncodeString", testEncodeString),
        ("testEncodeBool", testEncodeBool),
        ("testEncodeFloat", testEncodeFloat),
        ("testEmpty", testEmpty),
        ("testSnake", testSnake),
    ]
}

extension Array where Element == (String, String) {
    var queryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.0, value: $0.1) }
    }
}
