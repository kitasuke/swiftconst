//
//  StringVisitor.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct StringVisitor: SyntaxVisitor {
    
    let filePath: String
    let syntax: SourceFileSyntax
    var dataStore: DataStoreType
    
    public init(filePath: String, syntax: SourceFileSyntax, dataStore: DataStoreType) {
        self.filePath = filePath
        self.syntax = syntax
        self.dataStore = dataStore
    }
    
    // Ignore string interpolated literal because it's too complex to compare
    public mutating func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        guard node.segments.count == 1 else {
            return .skipChildren
        }
        return .visitChildren
    }

    public mutating func visit(_ node: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        let value = node.content.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty,
            value.count > 3 else {
            return .skipChildren
        }
        
        let sourceRange = node.sourceRange(converter: SourceLocationConverter(file: filePath, tree: syntax))
        let stringLiteral = FileString(value: value, line: sourceRange.start.line ?? 0, column: sourceRange.start.column ?? 0)
        dataStore.fileStrings.append(stringLiteral)
        
        return .skipChildren
    }
}
