import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftParser


public struct profilerMacro: ExpressionMacro {
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> ExprSyntax {
        
        
        _ = ProfilerMacro.createSourceCode()
    }

    static private func createVariable(identifier: String, expression: String) -> VariableDeclSyntax {
        let variableDecl =  VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            
            PatternBindingListSyntax(arrayLiteral: PatternBindingSyntax(pattern: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("\(identifier)"))), initializer: InitializerClauseSyntax(equal: .equalToken(leadingTrivia: .spaces(1), trailingTrivia: .spaces(1)), value: ExprSyntax(stringLiteral: "\(expression)")))
            )
        }
        return variableDecl
    }
    
    

    static private func createSourceCode() -> SourceFileSyntax {
        SourceFileSyntax {
            CodeBlockItemListSyntax {
                
                //let startTime = DispatchTime.now()
                CodeBlockItemSyntax(item: .decl(    DeclSyntax(profilerMacro.createVariable(identifier: "startTime", expression: "DispatchTime.now()"))))
                /*
                 defer {
                 let endTime = DispatchTime.now()
                 let timeElapsedInNanoSeconds = endTime.timeElapsedInNanoseconds - startTime.timeElapsedInNanoseconds
                 let timeElapsedInSeconds = Double(timeElapsedInNanoseconds) / 1_000_000_000
                 debugPrint("Took \(timeElapsedInSeconds) seconds")
                 }
                 */
                CodeBlockItemSyntax(item: .stmt(StmtSyntax(
                    DeferStmtSyntax(deferKeyword: .keyword(.defer),
                                    body: CodeBlockSyntax(leftBrace: .leftBraceToken()
                                                         ,statements:
                                                            
                                                            CodeBlockItemListSyntax {
                                                                // let endTime = DispatchTime.now()
                                                                CodeBlockItemSyntax(item: .decl(DeclSyntax(profilerMacro.createVariable(identifier: "endTime", expression: "DispatchTime.now()"))))
                                                                //let timeElapsedInNanoSeconds = endTime.timeElapsedInNanoseconds - startTime.timeElapsedInNanoseconds
                                                                CodeBlockItemSyntax(item: .decl(DeclSyntax(profilerMacro.createVariable(identifier: "timeElapsedInNanoseconds", expression: "endTime.uptimeNanoseconds - startTime.uptimeNanoseconds"))))
                                                                //let timeElapsedInSeconds = Double(timeElapsedInNanoseconds) / 1_000_000_000
                                                                CodeBlockItemSyntax(item: .decl(DeclSyntax(profilerMacro.createVariable(identifier: "timeElapsedInSeconds", expression: "Double(timeElapsedInNanoseconds) / 1_000_000_000"))))
                                                                //debugPrint("Took \(timeElapsedInSeconds) seconds")
                                                                CodeBlockItemSyntax(item: .expr(ExprSyntax(FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: .identifier("debugPrint")), arguments: TupleExprElementListSyntax {
                                                                    
                                                                    LabeledExprListSyntax {
                                                                        LabeledExprSyntax {
                                                                            
                                                                            StringLiteralExprSyntax(openingQuote: .stringQuoteToken(),
                                                                                                    segments: StringLiteralSegmentListSyntax {
                                                                                
                                                                                StringSegmentSyntax(
                                                                                    content: TokenSyntax.identifier("Took")
                                                                                )
                                                                                
                                                                                ExpressionSegmentSyntax(
                                                                                    backslash: .backslashToken(),
                                                                                    leftParen: .leftBraceToken(),
                                                                                    rightParen: .rightBraceToken()) {
                                                                                        LabeledExprListSyntax {
                                                                                            LabeledExprSyntax(expression: .expr(DeclReferenceExprSyntax(baseName: .identifier("timeElapsedInSeconds"))))
                                                                                        }
                                                                                    }
                                                                                
                                                                                StringSegmentSyntax(content: TokenSyntax.identifier("seconds"))
                                                                            },
                                                                                                    closingQuote: .stringQuoteToken()
                                                                            )
                                                                        }
                                                                    }
                                                                    
                                                                }))))
                                                            }
                                                         
                                                         , rightBrace: .rightBraceToken()
                                                        )))))
            }
        } //end of SourceFile
    }
}

@main
struct profilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ProfilerMacro.self,
    ]
}
