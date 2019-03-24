//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct DuplicationDetector {
    
    let syntax: SourceFileSyntax
    
    public init(fileURL: URL) throws {
        self.syntax = try SourceFileParser(pathURL: fileURL).parse()
    }
    
    public func detect() -> [FileString] {
        let dataStore = DataStore()
        StringVisitor(dataStore: dataStore).visit(syntax)
        return filter(dataStore.fileStrings)
    }
    
    private func filter(_ fileStrings: [FileString]) -> [FileString] {
        return fileStrings.filter { fileString in
            return fileStrings.filter { $0.value == fileString.value }.count > 1
        }
    }
}