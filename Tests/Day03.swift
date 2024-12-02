import Testing

@testable import AdventOfCode

struct Day03_Tests {
  let testData = ""

  @Test func testPart1() async throws {
    let challenge = Day03(data: testData)
    #expect(String(describing: challenge.part1()) == "11")
  }

  @Test func testPart2() async throws {
    let challenge = Day03(data: testData)
    #expect(String(describing: challenge.part2()) == "31")
  }
}
