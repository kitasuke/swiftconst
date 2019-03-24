//
//  StringVisitorTests.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax
import XCTest
@testable import SwiftConstCore

final class StringVisitorTests: XCTestCase {
    
    func test_stringVisitor() {
        let input = """
struct A {
    let bar = "ddd"

    func foo() -> String {
        // aaa
        let string = "aaa"
        print("bbb")
        return "ccc"

        let a = ""
        let b = ""
        a = b
    }
}
"""
        let url = createSourceFile(from: input)
        let syntax = try! SyntaxTreeParser.parse(url)
        
        let dataStore: DataStoreType = MockDataStore()
        StringVisitor(dataStore: dataStore).visit(syntax)
        
        XCTAssertEqual(dataStore.fileStrings, [
            .init(value: "\"ddd\"", lineNumber: 2, column: 15),
            .init(value: "\"aaa\"", lineNumber: 6, column: 22),
            .init(value: "\"bbb\"", lineNumber: 7, column: 15),
            .init(value: "\"ccc\"", lineNumber: 8, column: 16)]
        )
    }
}