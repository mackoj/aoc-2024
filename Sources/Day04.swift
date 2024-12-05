import Foundation

struct Day04: AdventDay {
  var data: String
  
  func extractVerticalInput(_ horizontalInput: [String]) -> [String] {
    guard let firstLine = horizontalInput.first, !firstLine.isEmpty else { return [] }
    let charCount = firstLine.count
    var result = [String](repeating: "", count: charCount)
    
    for line in horizontalInput where !line.isEmpty {
      for (index, char) in line.enumerated() {
        if index < charCount {
          result[index].append(char)
        }
      }
    }
    
    return result
  }
  
  func extractDiagonalInput(_ horizontalInput: [String]) -> [String] {
    let rowCount = horizontalInput.count
    guard rowCount > 0, let firstLine = horizontalInput.first else { return [] }
    let colCount = firstLine.count
    var diagonals: [String] = []
    
    // Collect diagonals from top-left to bottom-right
    for start in 0..<(rowCount + colCount - 1) {
      var diagonalTLBR = ""
      for i in 0..<rowCount {
        let j = start - i
        if j >= 0, j < colCount, i < rowCount, !horizontalInput[i].isEmpty {
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
        if j >= 0, j < colCount, i < rowCount, !horizontalInput[i].isEmpty {
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
    do {
      let horizontalCount = try horizontalInput.reduce(into: 0) { $0 += $1.matches(of: try Regex(word)).count }
      let verticalCount = try verticalInput.reduce(into: 0) { $0 += $1.matches(of: try Regex(word)).count }
      let diagonalCount = try diagonalInput.reduce(into: 0) { $0 += $1.matches(of: try Regex(word)).count }
      return horizontalCount + verticalCount + diagonalCount
    } catch {
      fatalError(error.localizedDescription)
    }
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
    let grid: [[Character]] = data
      .components(separatedBy: .newlines)
      .map(Array.init)
    var counter = 0
    for (line, row) in grid.enumerated() where line > 0 && line < (grid.count - 2) {
      for (column, character) in row.enumerated() where column > 0 && column < (row.count - 1) {
        if character == "A" {
          let topLeft = grid[line - 1][column - 1]
          let topRight = grid[line - 1][column + 1]
          let bottomLeft = grid[line + 1][column - 1]
          let bottomRight = grid[line + 1][column + 1]
          let diagonalL = (topLeft == "M" && bottomRight == "S") || (topLeft == "S" && bottomRight == "M")
          let diagonalR = (topRight == "M" && bottomLeft == "S") || (topRight == "S" && bottomLeft == "M")
          if diagonalL && diagonalR {
            counter += 1
          }
        }
      }
    }
    return counter
  }
}
