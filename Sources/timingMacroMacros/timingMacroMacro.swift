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
        // Extract the code block from the macro argument
        guard let codeBlock = node.argumentList.first?.expression.as(ClosureExprSyntax.self) else {
                    fatalError("Expected a code block as the argument.")
                }
        let startTimeCodeBlock = CodeBlockItemSyntax(stringLiteral: "let startTime = DispatchTime.now()")
        let newCodeBlock = CodeBlockItemSyntax(item: .expr(codeBlock.as(ExprSyntax.self)!))
        let timeElapsedCodeBlock =  CodeBlockItemSyntax(stringLiteral: """
            let endTime = DispatchTime.now()
            let timeElapsedInNanoSeconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let timeElapsedInSeconds = Double(timeElapsedInNanoSeconds) / 1_000_000_000
            print("Time elapsed: \\(timeElapsedInSeconds) seconds")
            """)
        
        var newStatementCodeBlock = [CodeBlockItemSyntax]()
        newStatementCodeBlock.append(startTimeCodeBlock)
        newStatementCodeBlock.append(newCodeBlock)
        newStatementCodeBlock.append(timeElapsedCodeBlock)
        
        let newBlock = CodeBlockSyntax {
              for item in newStatementCodeBlock {
                  item
              }
          }
        
        return [newBlock.as(DeclSyntax.self)!]
    }
}

@main
struct timingMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TimingMacro.self,
    ]
}
