import Testing

@testable import AdventOfCode

struct Day02_Tests {
  let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "2")
  }

  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "4")
  }
}
