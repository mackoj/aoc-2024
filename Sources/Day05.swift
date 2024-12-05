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
          let value = Int(last)
        {
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
        if let indexX = update.firstIndex(of: x), let indexY = update.firstIndex(of: y),
          indexX > indexY
        {
          return false
        }
      }
    }
    return true
  }

  func sortUpdates(_ update: [Int], rules: [(Int, Int)]) -> [Int] {
    var orderByPage = [Int: Set<Int>]()
    for (x, y) in rules {
      orderByPage[x, default: []].insert(y)
    }

    var newUpdate = update
    var needToBeSorted = true
    while needToBeSorted {
      needToBeSorted = false
      for i in 0..<newUpdate.count {
        for j in (i + 1)..<newUpdate.count {
          if let pagesThatAreAfter = orderByPage[newUpdate[i]],
            pagesThatAreAfter.contains(newUpdate[j])
          {
            newUpdate.swapAt(i, j)
            needToBeSorted = true
          }
        }
      }
    }
    return newUpdate
  }

  func part1() -> Any {
    return updates.reduce(into: 0) { partialResult, update in
      if isValidUpdate(update, rules: self.rules) {
        partialResult += update[update.count / 2]
      }
    }
  }

  func part2() -> Any {
    return updates.reduce(into: 0) { partialResult, update in
      if isValidUpdate(update, rules: self.rules) == false {
        let sorted = sortUpdates(update, rules: self.rules)
        partialResult += sorted[sorted.count / 2]
      }
    }
  }
}
