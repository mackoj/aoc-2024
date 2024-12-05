import Foundation

struct Day05: AdventDay {
  var data: String
  let rules: [(Int, Int)]
  let updates: [[Int]]

  init(data: String) {
    self.data = data
    var rules: [(Int, Int)] = []
    var updates: [[Int]] = []
    
    let regex = #/([\d]+\|[\d]+)|([\,\d]+)/#
    for line in data.components(separatedBy: .newlines) {
      let matches = line.matches(of: regex)
      for match in matches {
        if let ouput = match.output.1?.components(separatedBy: "|"),
           let first = ouput.first,
           let last = ouput.last,
           let index = Int(first),
           let value = Int(last) {
          rules.append((index, value))
        }
        if let output = match.output.2?.components(separatedBy: ",").compactMap(Int.init) {
          updates.append(output)
        }
      }
    }
    self.rules = rules
    self.updates = updates
  }
  
  func isValidUpdate(_ update: [Int], rules: [(Int, Int)]) -> Bool {
    let pageSet = Set(update)
    for (x, y) in rules {
      if pageSet.contains(x) && pageSet.contains(y) {
        if let indexX = update.firstIndex(of: x), let indexY = update.firstIndex(of: y), indexX > indexY {
          return false
        }
      }
    }
    return true
  }

  func sortUpdates(_ update: [Int], rules: [(Int, Int)]) -> [Int] {
    var ruleGraph: [Int: [Int]] = [:]
    for (x, y) in rules {
//      ruleGraph[y, default: []].append(x)
      ruleGraph[x, default: []].append(y)
    }
    var needToBeSorted = !isValidUpdate(update, rules: rules)
    var output = update
    while needToBeSorted {
      var newOutput: [Int] = []
      for (idx, page) in output.enumerated() {
        let head = idx > 0 ? output[...(idx-1)] : []
        let tail = ((idx + 1) < output.count) ? output[(idx+1)...] : []
        let numberThatShouldBeAfterMe = Set<Int>(ruleGraph[page] ?? [])
        let numberThatAreAfterMe = Set<Int>(tail)
        let numberToMoveBeforeMe = numberThatAreAfterMe.subtracting(numberThatShouldBeAfterMe)
        let numberThatWillBeAfterMe = numberThatAreAfterMe.intersection(numberThatShouldBeAfterMe)
        newOutput = head + numberToMoveBeforeMe + [page] + tail.filter { numberThatWillBeAfterMe.contains($0) }
        if output != newOutput {
          output = newOutput
          break
        }
      }
      // 97,75,47,61,53
      needToBeSorted = !isValidUpdate(output, rules: rules)
    }
    return output
  }
  
  
  func part1() -> Any {
    return updates.reduce(into: 0) { partialResult, update in
      if isValidUpdate(update, rules: self.rules) {
        partialResult += update[update.count/2]
      }
    }
  }
  
  func part2() -> Any {
    return updates.reduce(into: 0) { partialResult, update in
      if isValidUpdate(update, rules: self.rules) == false {
        var sorted = sortUpdates(update, rules: self.rules)
//        print("\(update) | \(sorted)")
        partialResult += sorted[sorted.count/2]
      }
    }
  }
}
