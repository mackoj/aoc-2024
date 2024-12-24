import Foundation
import Algorithms


var isRunningTests: Bool {
  return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

struct Day07: AdventDay {
  struct Operator: CustomStringConvertible {
    let name: String
    let operation: (Int, Int) -> Int
    var description: String { name }
  }
  
  var data: String
  
  func mainAlgo(_ operators: [Operator]) -> Int {
    var operations = 0
    data.enumerateLines { line, _ in
      // Prepare Input
      let resultAndOperations = line.components(separatedBy: ":")
      guard
        let first = resultAndOperations.first,
        let last = resultAndOperations.last,
        let targetResult = Int(first)
      else { return }
      
      let numbers = last
        .components(separatedBy: .whitespaces)
        .compactMap(Int.init)
      if isRunningTests {
        print("➡️ result: \(targetResult) - numbers: \(numbers)")
      }
      
      let possibilities = operators.generateCombinations(count: numbers.count - 1)
      
      for possibility in possibilities {
        var result = numbers[0]
        for (index, op) in possibility.enumerated() {
          result = op.operation(result, numbers[index + 1])
        }
        
        if result == targetResult {
          operations += targetResult
          if isRunningTests {
            print("✅ result: \(targetResult) - possibility: \(possibility)")
          }
          return
        }
      }
      
      if isRunningTests {
        print("🛑 result: \(targetResult) - possibilities: \(possibilities)")
      }
    }
    return operations
  }
  
  func part1() -> Any {
    let operators: [Operator] = [
      Operator(name: "Add", operation: { $0 + $1 }),
      Operator(name: "Multiply", operation: { $0 * $1 }),
    ]
    return mainAlgo(operators)
  }
  
  func part2() -> Any {
    let operators: [Operator] = [
      Operator(name: "Add", operation: { $0 + $1 }),
      Operator(name: "Multiply", operation: { $0 * $1 }),
      Operator(name: "Concat", operation: { Int("\($0)\($1)")! }),
    ]
    return mainAlgo(operators)
  }
}

extension Array {
  func generateCombinations(count: Int) -> [[Element]] {
    guard count > 0 else { return [[]] }
    var result: [[Element]] = [[]]
    for _ in 0..<count {
      result = result.flatMap { current in
        self.map { element in
          current + [element]
        }
      }
    }
    return result
  }
  
}
