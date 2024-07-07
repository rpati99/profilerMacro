//
//  timingMacroError.swift
//  
//
//  Created by Rachit Prajapati on 7/7/24.
//

import Foundation

enum MacroExpansionError: Error {
    case invalidExpression
    
    var description: String {
        switch self {
        case .invalidExpression:
            return "expression is not a closure"
        }
    }
}

