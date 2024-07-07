// The Swift Programming Language
// https://docs.swift.org/swift-book

@freestanding(declaration, names: named(run))
public macro timify(_ code: () -> Void) = #externalMacro(module: "timingMacroMacros", type: "TimingMacro")
