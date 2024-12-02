import Algorithms
import Parsing

struct Day02: AdventDay {
  var data: String
  let reports: [Report]
  
  init(data: String) {
    self.data = data
    do {
      self.reports = try Day02.parse(data)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func part1() -> Any {
    return reports.reduce(into: 0) { partialResult, report in
      if isSafeReport(report.levels) { partialResult += 1 }
    }
  }
  
  func part2() -> Any {
    return reports.reduce(into: 0) { partialResult, report in
      if isSafeWithOneRemoval(report.levels) { partialResult += 1 }
    }
  }
  
  // MARK: - Day 2
  func isSafeReport(_ levels: [Int]) -> Bool {
    guard levels.count >= 2 else { return false }
    guard let trend = Trend(levels[1] - levels[0]) else { return false }
    for i in 1..<levels.count {
      let diff = levels[i] - levels[i - 1]
      guard let diffTrend = Trend(diff) else { return false }
      let absDiff = abs(diff)
      if absDiff < 1 || absDiff > 3 { return false } // main rule
      switch (trend, diffTrend) {
        case (.increasing, .decreasing): return false
        case (.decreasing, .increasing): return false
        default: break
      }
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
  
  // MARK: - Models
  struct Report {
    let levels: [Int]
    
    init(levels: [Int]) {
      self.levels = levels
    }
  }
  
  enum Trend {
    case increasing
    case decreasing
    
    init?(_ trend: Int) {
      if trend > 0 {
        self = .increasing
      } else if trend < 0 {
        self = .decreasing
      } else {
        return nil
      }
    }
  }
  
  // MARK: Parsing
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
  
  static func parse(_ data: String) throws -> [Report] {
    try ReportsParser().parse(data)
  }
}
