import Foundation


// Random trial
func flipCoin() -> Bool {
  return arc4random_uniform(2) == 0 ? false : true
}

// Drops the ball and repeats the random trial `depth` times.
// Constrain the result to be in the range specified.
// Use an even depth to prevent bias.
public func dropBall(startPosition startPosition: Int,
                     depth: Int, range: Range<Int>) -> Int {
  
  var position = startPosition
  
  for d in 0 ..< depth {
    let bump = d % 2 == 0 ? 1 : -1
    position += flipCoin() ? bump : 0
    position = min(max(range.startIndex,position),range.endIndex-1)
  }
  
  return position
}