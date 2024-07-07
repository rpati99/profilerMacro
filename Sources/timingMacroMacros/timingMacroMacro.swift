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
        class CodePerformanceAnalyzer {
            // Measures the execution time of a closure
            private func measureExecutionTime() -> TimeInterval {
                let startTime = Date()
                \(declaration)
                let endTime = Date()
                return endTime.timeIntervalSince(startTime)
            }
            
            // Public method to log the execution time with a description
            public func logExecutionTime(withDescription description: String) {
                let duration = measureExecutionTime()
                print("\\(description): Took \\(duration) seconds")
            }

            // Public method to measure and return the average execution time of a closure repeated a specified number of times
            public func measureAverageTime(repeatCount: Int) -> TimeInterval {
                guard repeatCount > 0 else {
                    print("Repeat count must be greater than 0.")
                    return 0
                }
                let totalDuration = (1...repeatCount).reduce(0.0) { accumulatedDuration, _ in
                    accumulatedDuration + measureExecutionTime()
                }
                return totalDuration / Double(repeatCount)
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
