import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(timingMacroMacros)
import timingMacroMacros

let testMacros: [String: Macro.Type] = [
    "timify": TimingMacro.self,
]
#endif

final class timingMacroTests: XCTestCase {
    
    func testTimingMacro() throws {
        #if canImport(timingMacroMacros)
        assertMacroExpansion(
            #"""
            #timify({
                print("Hello World")
            })
            """#,
            expandedSource: """
        class CodePerformanceAnalyzer {
            // Measures the execution time of a closure
            private static func measureExecutionTime() -> TimeInterval {
                let startTime = Date()

            print("Hello World")
                let endTime = Date()
                return endTime.timeIntervalSince(startTime)
            }

            // Public method to log the execution time with a description
            public static func logExecutionTime(withDescription description: String) {
                let duration = measureExecutionTime()
                print("\\(description): Took \\(duration) seconds")
            }

            // Public method to measure and return the average execution time of a closure repeated a specified number of times
            public static func measureAverageTime(repeatCount: Int) -> TimeInterval {
                guard repeatCount > 0 else {
                    print("Repeat count must be greater than 0.")
                    return 0
                }
                let totalDuration = (1 ... repeatCount).reduce(0.0) { accumulatedDuration, _ in
                    accumulatedDuration + measureExecutionTime()
                }
                return totalDuration / Double(repeatCount)
            }
        }
        """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
