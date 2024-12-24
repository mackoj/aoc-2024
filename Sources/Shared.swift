import Foundation

var isRunningTests: Bool {
  return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
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

typealias Grid = [[Character]]

extension Grid {
  func buildDebugOutput(
    customs: [Character: Set<Point>]
  ) -> String {
    var newOutput = self
    for custom in customs {
      for point in custom.value {
        newOutput[point.x][point.y] = custom.key
      }
    }
    return newOutput.reduce("") { $0+$1+"\n" }
  }
}
