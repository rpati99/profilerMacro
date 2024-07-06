// The Swift Programming Language
// https://docs.swift.org/swift-book

@freestanding(declaration, names: named(Profile))
public macro timify() = #externalMacro(module: "timingMacroMacros", type: "TimingMacro")
