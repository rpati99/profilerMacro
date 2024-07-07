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
            #timify ({
                var i = 0
                for _ in 1_000 {
                    i += 1
                }
            })
            """#,
            expandedSource: """
                let startTime = DispatchTime.now()
                    
                        var i = 0
                        for _ in 1_000 {
                            i += 1
                        }
                    let endTime = DispatchTime.now()
                    let timeElapsedInNanoSeconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let timeElapsedInSeconds = Double(timeElapsedInNanoSeconds) / 1_000_000_000
                    print("Time elapsed: \\(timeElapsedInSeconds) seconds")
                """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
