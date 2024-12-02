import Algorithms
import Parsing

struct Day02: AdventDay {
  var data: String
  
  func parse() throws -> [Report] {
    try ReportsParser().parse(data)
  }
  
  func part1() -> Any {
    let reports = (try? parse()) ?? []
    return reports.filter(\.isSafe).count
  }

  func part2() -> Any {
    let reports = (try? parse()) ?? []
    return reports.filter(\.isSafe2).count
  }
}

struct Report {
  let levels: [Int]
  let isSafe: Bool
  let isSafe2: Bool

  enum Mode {
    case increasing
    case decreasing
  }
  
  init(levels: [Int]) {
    self.levels = levels
    
    // part1
    var isSafe = true
    var progressionLevel: Set<Mode> = []
    var previousLevel: Int? = nil

    for level in levels {
      defer { previousLevel = level }
      guard let previousLevel else { continue }
      
      if level > previousLevel {
        progressionLevel.insert(.increasing)
      } else {
        progressionLevel.insert(.decreasing)
      }
      
      let abs = abs(previousLevel - level)
      if abs <= 3, abs >= 1, isSafe {
        isSafe = true
      } else {
        isSafe = false
      }
    }
    if progressionLevel.count != 1 {
      isSafe = false
    }
    self.isSafe = isSafe
    
    // part2
    var isSafe2 = true
    var hasUseJoker = false
    var isSafe2Previous = true
    var progressionLevel2: Set<Mode> = []
    var previousLevel2: Int? = nil
    var lastMode: Mode = .increasing

    for (index, level) in levels.enumerated() {
      defer {
        previousLevel2 = level
        isSafe2Previous = isSafe2
      }
      guard let previousLevel2 else { continue }
      
      if level > previousLevel2 {
        lastMode = .increasing
        progressionLevel2.insert(.increasing)
      } else {
        lastMode = .decreasing
        progressionLevel2.insert(.decreasing)
      }
      
      let _abs = abs(previousLevel2 - level)
      if _abs <= 3, _abs >= 1, isSafe2 {
        isSafe2 = true
      } else {
        isSafe2 = false
      }
      if progressionLevel2.count != 1 {
        isSafe2 = false
      }
      
      if isSafe2 == false, isSafe2Previous == true, hasUseJoker == false, index-2 >= 0 {
        _ = progressionLevel2.remove(lastMode)
        let newPreviousLevel = levels[index-2]
        
        if level > newPreviousLevel {
          progressionLevel2.insert(.increasing)
        } else {
          progressionLevel2.insert(.decreasing)
        }
        
        let _abs = abs(newPreviousLevel - level)
        if _abs <= 3, _abs >= 1, isSafe2Previous {
          isSafe2 = true
        } else {
          isSafe2 = false
        }
        if progressionLevel2.count != 1 {
          isSafe2 = false
        }
        hasUseJoker = true
      }
    }
    self.isSafe2 = isSafe2
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
