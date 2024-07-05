import profiler

let a = 17
let b = 25
 
let code: () = #profiler

print("The value \(code) was produced by the code \"\(code)\"")
