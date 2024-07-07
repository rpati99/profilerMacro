import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftParser

enum MacroExpansionError: Error {
    case message(String)
}

public struct TimingMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = node.argumentList.first?.expression.as(ClosureExprSyntax.self)?.statements else {
//            throw fatalError("The #timify macro must be attached to a valid declaration.")
            return []
        }

        let timeWrappedCode = """
        func run() {
            do {
                let startTime = DispatchTime.now()
                defer {
                    let endTime = DispatchTime.now()
                    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let milliseconds = Double(nanoseconds) / 1_000_000
                    print(milliseconds)
                }
                \(declaration)
            }
        }
        """
        
        return [DeclSyntax(stringLiteral: timeWrappedCode)]
    }
}

@main
struct timingMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TimingMacro.self,
    ]
}
