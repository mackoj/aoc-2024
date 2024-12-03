import Foundation
import RegexBuilder

struct Day03: AdventDay {
  var data: String

  struct Multiplication: Equatable {
    let lhs: Int
    let rhs: Int
  }
  
  func part1() -> Any {
    let regex = #/mul\((\d{1,3}),(\d{1,3})\)/#
    let matches = data.matches(of: regex)
    let multiplications = matches.reduce(into: [Multiplication]()) { partialResult, match in
      if let lhs = Int(match.output.1),
         let rhs = Int(match.output.2) {
        partialResult.append(Multiplication(lhs: lhs, rhs: rhs))
      }
    }
    return multiplications.reduce(0) { $0 + $1.lhs * $1.rhs }
  }

  func part2() -> Any {
    let regexMul = #/mul\((\d{1,3}),(\d{1,3})\)/#
    let matchesMul = data.matches(of: regexMul)
    let regexDo = #/do\(\)/#
    let matchesDo = data.matches(of: regexDo)
    let regexDont = #/don\'t\(\)/#
    let matchesDont = data.matches(of: regexDont)
    
    let multiplications = matchesMul.reduce(into: [Multiplication]()) { partialResult, match in
      var lastDontRange: String.Index?
      var lastDoRange: String.Index?
      for matchDo in matchesDo {
        if matchDo.range.lowerBound < match.range.lowerBound {
          lastDoRange = matchDo.range.lowerBound
        }
      }
      for matchDont in matchesDont {
        if matchDont.range.lowerBound < match.range.lowerBound {
          lastDontRange = matchDont.range.lowerBound
        }
      }
      
      switch (lastDoRange, lastDontRange) {
        case (.none, .none): break
        case (.none, .some(_)):  return
        case (.some(_), .none): break
        case let (.some(doRange), .some(dontRange)):
          if dontRange > doRange { return }
          else { break }
      }
      
      if let lhs = Int(match.output.1),
         let rhs = Int(match.output.2) {
        partialResult.append(Multiplication(lhs: lhs, rhs: rhs))
      }
    }
    return multiplications.reduce(0) { $0 + $1.lhs * $1.rhs }
  }
}
