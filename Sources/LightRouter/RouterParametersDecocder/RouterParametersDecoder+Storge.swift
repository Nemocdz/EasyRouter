//
//  File.swift
//  
//
//  Created by Nemo on 2021/6/17.
//

import Foundation

extension RouterParametersDecoder {
    struct Storage {
        private(set) var containers: [Any] = []

        var count: Int { containers.count }

        var topContainer: Any {
            precondition(!self.containers.isEmpty, "Empty container stack.")
            return containers.last!
        }

        mutating func push(container: Any) {
            containers.append(container)
        }

        mutating func popContainer() {
            precondition(!self.containers.isEmpty, "Empty container stack.")
            containers.removeLast()
        }
    }
}
