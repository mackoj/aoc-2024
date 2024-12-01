import Algorithms

struct Day01: AdventDay {
  var data: String
  
  func lists(_ data: String) -> (l1: [Int], l2: [Int]) {
    var l1: [Int] = []
    var l2: [Int] = []
    for line in data.split(separator: "\n") {
      let splitted = line.split(separator: "   ", omittingEmptySubsequences: true)
      if splitted.count == 2 {
        let tmpl1 = splitted[0]
        let tmpl2 = splitted[1]
        if let firstNumber = Int(tmpl1), let secondNumber = Int(tmpl2) {
          l1.append(firstNumber)
          l2.append(secondNumber)
        }
      }
    }
    return (l1, l2)
  }
  
  func part1() -> Any {
    let (l1, l2) = lists(data)
    let sortedList = zip(l1.sorted(), l2.sorted())
    let distances = sortedList.map { abs($0 - $1) }
    return distances.reduce(0, +)
  }
  
  func part2() -> Any {
    let (l1, l2) = lists(data)
    return l1.reduce(into: 0) { partialResult, input in
      let rep = l2.lazy.filter { $0 == input }.count
      partialResult += input * rep
    }
  }
}
