import Foundation
import Algorithms

struct Day06: AdventDay {
  var data: String
  let grid: Grid
  let guardian: Point?
  let obstructions: Set<Point>
  let obstruction: Character = "#"
  
  init(data: String) {
    self.data = data
    self.grid = data.components(separatedBy: .newlines).map(Array.init)
    
    var guardian: Point? = nil
    var obstructions: Set<Point> = Set<Point>()
    
    for i in 0..<grid.count {
      for j in 0..<grid[i].count {
        if grid[i][j] == obstruction {
          obstructions.insert(Point(x: Int(i), y: Int(j)))
        } else if Orientation(rawValue: grid[i][j]) != nil {
          guardian = Point(x: Int(i), y: Int(j))
        }
      }
    }
    self.guardian = guardian
    self.obstructions = obstructions
  }
  
  func findNextObstruction(from point: Point, orientation: Orientation) -> (
    next: Point?,
    path: Array<Point>,
    nextOrientation: Orientation
  ) {
    var maxX: [Int]
    var maxY: [Int]
    
    var path = Array<Point>()
    
    switch orientation {
      case .top:
        maxX = Array(0..<point.x).reversed()
        maxY = Array(point.y..<point.y+1)
      case .right:
        maxX = Array(point.x..<point.x+1)
        maxY = Array(point.y..<grid[0].count)
      case .bottom:
        maxX = Array(point.x..<grid.count)
        maxY = Array(point.y..<point.y+1)
      case .left:
        maxX = Array(point.x..<point.x+1)
        maxY = Array(0..<point.y).reversed()
    }
    
    for mx in maxX {
      for my in maxY {
        if grid[mx][my] == obstruction {
          return (path.last, path, orientation.next)
        }
        path.append(Point(x: mx, y: my))
      }
    }
    
    return (nil, path, orientation)
  }
  
  func part1() -> Any {
    guard let guardian else { return 0 }
    guard var orientation = Orientation(rawValue: grid[guardian.x][guardian.y]) else {
      return 0
    }
    
    var movingGuardian = guardian
    var patroling = true
    var path: Set<Point> = Set<Point>([guardian])
    while patroling {
      let (newGuardianPosition, locations, nextOrientation) = findNextObstruction(from: movingGuardian, orientation: orientation)
      path.formUnion(locations)
      if isRunningTests {
        print(grid.buildDebugOutput(customs: [
          "X": path,
          "^": Set([guardian])
        ]))
      }

      if let newGuardianPosition {
        movingGuardian = newGuardianPosition
        orientation = nextOrientation
      } else {
        patroling = false
      }
    }
    return path.count
  }
  
  func findNextObstruction2(from point: Point, orientation: Orientation) -> (
    next: Point?,
    path: [Point],
    nextOrientation: Orientation
  ) {
    let directions: (dx: Int, dy: Int)
    switch orientation {
      case .top: directions = (-1, 0)
      case .right: directions = (0, 1)
      case .bottom: directions = (1, 0)
      case .left: directions = (0, -1)
    }
    
    var path = [Point]()
    var current = point
    
    while true {
      let next = Point(x: current.x + directions.dx, y: current.y + directions.dy)
      if next.x < 0 || next.y < 0 || next.x >= grid.count || next.y >= grid[0].count {
        return (nil, path, orientation)
      }
      if grid[next.x][next.y] == obstruction {
        return (next, path, orientation.next)
      }
      path.append(next)
      current = next
    }
  }
  
  func willItLoop2(_ path: Set<Point>, _ newLineSegment: [Point], _ orientation: Orientation) -> Point? {
    for possibleBlock in newLineSegment[1...] {
      let (newGuardianPosition, _, _) = findNextObstruction2(from: possibleBlock, orientation: orientation)
      guard let newGuardianPosition else { continue }
      if path.contains(newGuardianPosition) {
        return possibleBlock
      }
    }
    return nil
  }
  
  func part2() -> Any {
    guard let guardian else { return 0 }
    guard var orientation = Orientation(rawValue: grid[guardian.x][guardian.y]) else {
      return 0
    }
    
    var movingGuardian = guardian
    var patroling = true
    var path: Set<Point> = Set<Point>([guardian])
    var lineSegments: [[Point]] = []
    var newBlockers = Set<Point>()
    
    while patroling {
      let (newGuardianPosition, locations, nextOrientation) = findNextObstruction(from: movingGuardian, orientation: orientation)
      path.formUnion(locations)
      lineSegments.append(locations)
      if isRunningTests {
        print(grid.buildDebugOutput(customs: [
          "X": path,
          "O": newBlockers,
          "^": Set([guardian])
        ]))
      }
      if lineSegments.count > 2 {
        if let blocker = willItLoop2(path, locations, nextOrientation) {
          newBlockers.insert(blocker)
        }
      }
      
      if let newGuardianPosition {
        movingGuardian = newGuardianPosition
        orientation = nextOrientation
      } else {
        patroling = false
      }
    }
    
    return newBlockers.count
  }
}

struct Point: Hashable, Sendable {
  var x: Int
  var y: Int
}

enum Orientation: Character, RawRepresentable {
  case top = "^"
  case right = ">"
  case bottom = "v"
  case left = "<"
  
  var next: Orientation {
    switch self {
      case .top: return .right
      case .right: return .bottom
      case .bottom: return .left
      case .left: return .top
    }
  }
}
