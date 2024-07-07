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
            func run() {
                do {
                    let startTime = DispatchTime.now()
                    defer {
                        let endTime = DispatchTime.now()
                        let nanoseconds = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                        let milliseconds = Double(nanoseconds) / 1_000_000
                        print(milliseconds)
                    }

                print("Hello World")
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
