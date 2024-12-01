import Testing

@testable import AdventOfCode

// One off test to validate that basic data load testing works
struct AdventDayTests {

  @Test func testInitData() async throws {
    let challenge = Day01()
    #expect(challenge.data.starts(with: "18944   47230"))
  }
}
