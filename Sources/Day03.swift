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
    
    var doPositions: [String.Index] = matchesDo.map { $0.range.lowerBound }
    var dontPositions: [String.Index] = matchesDont.map { $0.range.lowerBound }
    
    return matchesMul.reduce(into: 0) { partialResult, match in
      let matchPosition = match.range.lowerBound
      let lastDo = doPositions.last { $0 < matchPosition }
      let lastDont = dontPositions.last { $0 < matchPosition }
      
      switch (lastDo, lastDont) {
        case (.none, .none): break
        case (.none, .some(_)): return
        case (.some(_), .none): break
        case let (.some(doPos), .some(dontPos)):
          if dontPos > doPos { return }
          else { break }
      }
      
      if let lhs = Int(match.output.1),
         let rhs = Int(match.output.2) {
        partialResult += lhs * rhs
      }
    }
  }
}
