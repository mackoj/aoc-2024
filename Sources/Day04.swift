import Foundation

struct Day04: AdventDay {
  var data: String

  init(data: String) {
    self.data = data
  }
  
  func extractVerticalInput(_ horizontalInput: [String]) -> [String] {
    let charCount = horizontalInput[0].count
    var result = [String](repeating: "", count: charCount)
    
    for line in horizontalInput where !line.isEmpty {
        for (index, char) in line.enumerated() {
            result[index].append(char)
        }
    }
    
    return result
  }
  
  func extractDiagonalInput(_ horizontalInput: [String]) -> [String] {
    let rowCount = horizontalInput.count
    let colCount = horizontalInput[0].count
    var diagonals: [String] = []

    // Collect diagonals from top-left to bottom-right
    for start in 0..<(rowCount + colCount - 1) {
        var diagonalTLBR = ""
        for i in 0..<rowCount {
            let j = start - i
            if j >= 0 && j < colCount {
                diagonalTLBR.append(horizontalInput[i][horizontalInput[i].index(horizontalInput[i].startIndex, offsetBy: j)])
            }
        }
        if !diagonalTLBR.isEmpty {
            diagonals.append(diagonalTLBR)
        }
    }

    // Collect diagonals from top-right to bottom-left
    for start in 0..<(rowCount + colCount - 1) {
        var diagonalTRBL = ""
        for i in 0..<rowCount {
            let j = colCount - 1 - (start - i)
            if j >= 0 && j < colCount {
                diagonalTRBL.append(horizontalInput[i][horizontalInput[i].index(horizontalInput[i].startIndex, offsetBy: j)])
            }
        }
        if !diagonalTRBL.isEmpty {
            diagonals.append(diagonalTRBL)
        }
    }

    return diagonals
  }

  
  func countForWord(_ word: String, _ horizontalInput: [String], _ verticalInput: [String], _ diagonalInput: [String]) -> Int {
    let horizontalCount = horizontalInput.filter { $0.contains(word) }.count
    let verticalCount = verticalInput.filter { $0.contains(word) }.count
    let diagonalCount = diagonalInput.filter { $0.contains(word) }.count
    return horizontalCount + verticalCount + diagonalCount
  }
  
  func part1() -> Any {
    let horizontalInput = data.components(separatedBy: .newlines)
    let verticalInput = extractVerticalInput(horizontalInput)
    let diagonalInput = extractDiagonalInput(horizontalInput)
    return countForWord(
      "XMAS",
      horizontalInput,
      verticalInput,
      diagonalInput
    ) + countForWord(
      "SAMX",
      horizontalInput,
      verticalInput,
      diagonalInput
    )
  }

  func part2() -> Any {
    return 0
  }
}
