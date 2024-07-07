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
            func measure() {
                            let startTime = DispatchTime.now()
                            defer {
                                    let endTime = DispatchTime.now()
                                    let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                                    let milliseconds = Double(nanoseconds) / 1_000_000
                                    print("Execution Time: \\(milliseconds) milliseconds")
                            }

                        print("Hello World")
                            print("Executing profiled code...")
                            print("Sample output from profiled code: This runs automatically!")
                }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
