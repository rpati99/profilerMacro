import timingMacro
import Foundation 
    
// This is a file to see the usage of the macro and the generated class methods. 
    
#timify({
    print("hello world")
})

//Usage
CodePerformanceAnalyzer.logExecutionTime(withDescription: "This is a log message")
let rec_time_avg = CodePerformanceAnalyzer.measureAverageTime(repeatCount: 3)
debugPrint(rec_time_avg)
