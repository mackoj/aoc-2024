import Foundation
import RegexBuilder

struct Day03: AdventDay {
  var data: String
  
  func part1() -> Any {
    let regex = #/mul\((\d{1,3}),(\d{1,3})\)/#
    let matches = data.matches(of: regex)
    return matches.reduce(into: 0) { partialResult, match in
      if let lhs = Int(match.output.1),
         let rhs = Int(match.output.2) {
        partialResult += lhs * rhs
      }
    }
  }

  func part2() -> Any {
    let regexMul = #/mul\((\d{1,3}),(\d{1,3})\)/#
    let matchesMul = data.matches(of: regexMul)
    let regexDo = #/do\(\)/#
    let matchesDo = data.matches(of: regexDo)
    let regexDont = #/don\'t\(\)/#
    let matchesDont = data.matches(of: regexDont)
    
    return matchesMul.reduce(into: 0) { partialResult, match in
      var lastDontRange: String.Index?
      var lastDoRange: String.Index?
      for matchDo in matchesDo where matchDo.range.lowerBound < match.range.lowerBound {
        lastDoRange = matchDo.range.lowerBound
      }
      for matchDont in matchesDont where matchDont.range.lowerBound < match.range.lowerBound {
        lastDontRange = matchDont.range.lowerBound
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
        partialResult += lhs * rhs
      }
    }
  }
}
