*A freestanding declaration macro that generates code that contains methods which measure time elapsed to run the desired code snippet.*
 

## Usage

`#timify({ code here })`

for example:
```
#timify({
  var count = 0
  for _ in 0...1_000 {
    count += 1
  }
})
```

## Method access:- 

**The generated class (CodePerformanceAnalyzer) contains 2 static methods.**

- Log the time 
`CodePerformanceAnalyzer.logExecutionTime(description: "description here")`

- Getting the average time based on desired iterations
`CodePerformanceAnalyzer.measureAverageTime(repeatCount: Int) -> TimeInterval`

