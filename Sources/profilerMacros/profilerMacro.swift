import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftParser

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
//public struct StringifyMacro: ExpressionMacro {
//    public static func expansion(
//        of node: some FreestandingMacroExpansionSyntax,
//        in context: some MacroExpansionContext
//    ) -> ExprSyntax {
//        guard let argument = node.argumentList.first?.expression else {
//            fatalError("compiler bug: the macro does not have any arguments")
//        }
//
//        return "(\(argument), \(literal: argument.description))"
//    }
//}

public struct ProfileMacro: DeclarationMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        
    
        return [
        """
        class Profile {
            private func initStartTime() {
                let startTime = DispatchTime.now()
            }

            private func calculateTime() {
                let endTime = DispatchTime.now()
                let timeElapsedInNanoSeconds = endTime.timeInNanoseconds - startTime.timeInNanoseonds
                let timeElapsedInSeconds = Double(timeElapsedInNanoSeconds) / 1_000_000_000
                debugPrint(timeElapsedInSeconds)
            }

            func measureTime() -> Double {
                initStartTime()
                defer {
                    calculateTime()
                }
            }
        }
        """
        ]
    }
}

@main
struct profilerMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ProfileMacro.self
    ]
}


