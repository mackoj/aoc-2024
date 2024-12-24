import Foundation
import Algorithms


var isRunningTests: Bool {
  return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

struct Day07: AdventDay {
  var data: String
  
  init(data: String) {
    self.data = data
  }
  
  func generateCombinations<T>(from array: [T], count: Int) -> [[T]] {
      guard count > 0 else { return [[]] }
      
      var result: [[T]] = [[]]
      
      for _ in 0..<count {
          result = result.flatMap { current in
              array.map { element in
                  current + [element]
              }
          }
      }
      
      return result
  }
  
  func part1() -> Any {
    let operators: [String] = [
      "add",
      "mul",
    ]
    var operations: Int = 0
    data
      .enumerateLines {
        line,
        _ in
        // Prepare Input
        let resultAndOperations = line.components(separatedBy: ":")
        guard
          let first = resultAndOperations.first,
          let last = resultAndOperations.last,
          let operationResult = Int(first)
        else { return }
        let remainingNumbers = last
          .components(separatedBy: .whitespaces)
          .compactMap(Int.init)
        
        let possibilities = generateCombinations(
          from: operators,
          count: remainingNumbers.count - 1
        )
        if isRunningTests {
          print("possibilities:", possibilities)
        }
        let res = possibilities.reduce(into: [Int: [String]]()) { result, possibility in
          var cons = remainingNumbers
          var possibility = possibility
          var possibility2 = possibility
          var output = 0
          while cons.count > 0 {
            if output == 0 {
              output = cons.removeFirst()
            } else {
              let l = cons.removeFirst()
              let op = possibility.removeFirst()
              switch op {
                case "add": output += l
                case "mul": output *= l
                default: break
              }
            }
          }
          result[output] = possibility2
        }
        if res[operationResult] != nil {
          if isRunningTests {
            print("✅ result: \(operationResult) - \(res[operationResult]!)")
          }
          operations += operationResult
        } else {
          if isRunningTests {
            print("🛑 result: \(operationResult)")
          }
        }
      }
    return operations
  }
  
  func part2() -> Any {
    let operators: [String] = [
      "add",
      "mul",
      "concat",
    ]
    var operations: Int = 0
    data
      .enumerateLines {
        line,
        _ in
        // Prepare Input
        let resultAndOperations = line.components(separatedBy: ":")
        guard
          let first = resultAndOperations.first,
          let last = resultAndOperations.last,
          let operationResult = Int(first)
        else { return }
        let remainingNumbers = last
          .components(separatedBy: .whitespaces)
          .compactMap(Int.init)
        
        let possibilities = generateCombinations(
          from: operators,
          count: remainingNumbers.count - 1
        )
        if isRunningTests {
          print("possibilities:", possibilities)
        }
        let res = possibilities.reduce(into: [Int: [String]]()) { result, possibility in
          var cons = remainingNumbers
          var possibility = possibility
          var possibility2 = possibility
          var output = 0
          while cons.count > 0 {
            if output == 0 {
              output = cons.removeFirst()
            } else {
              let l = cons.removeFirst()
              let op = possibility.removeFirst()
              switch op {
                case "add": output += l
                case "mul": output *= l
                case "concat":
                  if let nv = Int("\(output)\(l)") {
                    output = nv
                  }
                default: break
              }
            }
          }
          result[output] = possibility2
        }
        if res[operationResult] != nil {
          if isRunningTests {
            print("✅ result: \(operationResult) - \(res[operationResult]!)")
          }
          operations += operationResult
        } else {
          if isRunningTests {
            print("🛑 result: \(operationResult) - \(remainingNumbers)")
          }
        }
      }
    return operations
  }
}
