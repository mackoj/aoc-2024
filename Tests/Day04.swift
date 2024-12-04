import Testing

@testable import AdventOfCode

struct Day04_Tests {
  @Test func testPart1() async throws {
    let challenge = Day04(data: """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""")
    #expect(String(describing: challenge.part1()) == "18")
  }

  @Test func testPart2() async throws {
    let challenge = Day04(data: "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
    #expect(String(describing: challenge.part2()) == "48")
  }
}
