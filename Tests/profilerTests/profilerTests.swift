import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(profilerMacros)
import profilerMacros

let testMacros: [String: Macro.Type] = [
    "profile": ProfileMacro.self
    
]
#endif

final class profilerMacroTests: XCTestCase {
    func testProfileMacro() throws {
        #if canImport(profilerMacros)
        assertMacroExpansion(
            "#profile()",
            expandedSource: #"""
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

                @discardableResult
                func measureTime(codeBlock: () -> Void) {
                    initStartTime()
                    defer {
                        calculateTime()
                    }
                }
            }
        """#,
            macros: testMacros)
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    
    
}
