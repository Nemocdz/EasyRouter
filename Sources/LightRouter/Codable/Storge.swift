//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

struct Storage {
    private(set) var containers: [Any] = []

    var count: Int { containers.count }

    var topContainer: Any {
        precondition(!containers.isEmpty, "Empty container stack.")
        return containers.last!
    }

    mutating func push(container: Any) {
        containers.append(container)
    }

    mutating func popContainer() {
        precondition(!containers.isEmpty, "Empty container stack.")
        containers.removeLast()
    }
}
