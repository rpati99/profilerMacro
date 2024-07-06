import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")

public struct TimingMacro :DeclarationMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        return [
        """
        class Profile {
            private var startTime: DispatchTime?

            private func initStartTime() {
                startTime = DispatchTime.now()
            }

            private func calculateTime() {
                guard let startTime = self.startTime else {
                    print("Start time not initialized")
                    return
                }
                let endTime = DispatchTime.now()
                let timeElapsedInNanoSeconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                let timeElapsedInSeconds = Double(timeElapsedInNanoSeconds) / 1_000_000_000
                debugPrint(timeElapsedInSeconds)
            }
        
            func measureTime(codeBlock: () -> Void) {
                initStartTime()
                do {
                    calculateTime()
                }
            }
        }
        """
        ]
    }
    
    
    
}

@main
struct timingMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TimingMacro.self,
    ]
}
