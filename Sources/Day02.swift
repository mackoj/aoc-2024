import Algorithms
import Parsing

struct Day02: AdventDay {
  var data: String
  
  struct Report {
    let levels: [Int]
    
    init(levels: [Int]) {
      self.levels = levels
    }
  }

  struct ReportParser: Parser {
    var body: some Parser<Substring, Report> {
      Many {
        Int.parser()
      } separator: {
        " "
      }.map(Report.init(levels:))
    }
  }

  struct ReportsParser: Parser {
    var body: some Parser<Substring, [Report]> {
      Many {
        ReportParser()
      } separator: {
        "\n"
      }
    }
  }

  func parse() throws -> [Report] {
    try ReportsParser().parse(data)
  }
  
  func isSafeReport(_ levels: [Int]) -> Bool {
    guard levels.count >= 2 else { return false }
    let trend = levels[1] - levels[0]
    if trend == 0 { return false } // flat
    let isIncreasing = trend > 0
    let isDecreasing = trend < 0
    for i in 1..<levels.count {
      let diff = levels[i] - levels[i - 1]
      let diffTrendIsIncreasing = diff >= 0
      let diffTrendIsDecreasing = diff <= 0
      let absDiff = abs(diff)
      if absDiff < 1 || absDiff > 3 { return false }
      if isIncreasing && diffTrendIsIncreasing { return false }
      if isDecreasing && diffTrendIsDecreasing { return false }
    }
    return true
  }

  func isSafeWithOneRemoval(_ levels: [Int]) -> Bool {
    // normal case
    if isSafeReport(levels) {
      return true
    }
    
    // Test all of them fugly but works
    for i in 0..<levels.count {
      var modifiedLevels = levels
      modifiedLevels.remove(at: i)
      if isSafeReport(modifiedLevels) {
          return true
      }
    }

    return false
  }
  
  func part1() -> Any {
    let reports = (try? parse()) ?? []
    return reports.reduce(into: 0) { partialResult, report in
      if isSafeReport(report.levels) { partialResult += 1 }
    }
  }
  
  func part2() -> Any {
    let reports = (try? parse()) ?? []
    return reports.reduce(into: 0) { partialResult, report in
      if isSafeWithOneRemoval(report.levels) { partialResult += 1 }
    }
  }
}
