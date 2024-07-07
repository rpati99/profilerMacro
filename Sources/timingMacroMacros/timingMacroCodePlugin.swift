//
//  File.swift
//  
//
//  Created by Rachit Prajapati on 7/7/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros


@main
struct timingMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TimingMacro.self,
    ]
}
