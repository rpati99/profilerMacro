import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftParser

enum MacroExpansionError: Error {
    case invalidExpression
    
    var description: String {
        switch self {
        case .invalidExpression:
            return "expression is not a closure"
        }
    }
}

public struct TimingMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = node.argumentList.first?.expression.as(ClosureExprSyntax.self)?.statements else {
            throw MacroExpansionError.invalidExpression
        }

        let timeWrappedCode = """
        class Profile {
            static func measure() {
                let startTime = DispatchTime.now()
                defer {
                    let endTime = DispatchTime.now()
                    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let milliseconds = Double(nanoseconds) / 1_000_000
                    print("Execution Time: \\(milliseconds) milliseconds")
                }
                \(declaration)
                print("Executing profiled code...")
                print("Sample output from profiled code: This runs automatically!")
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
