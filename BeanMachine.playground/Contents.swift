import UIKit
import XCPlayground

//: ## Swift Bean Machine
//: A simplified bean machine simulation.
//:
//: [Wikipedia Article](https://en.wikipedia.org/wiki/Bean_machine)

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

func run() {
  let size = 50
  let depth = 50
  let trials = 100000

  var results = Results(size: size)

  for _ in 1...trials {
    let finalPosition = dropBall(startPosition: size/2, depth: depth, range: 0..<size)
    results.add(finalPosition)
    results   // Watch this variable with quick look
  }
}

// Uncomment to run
// run()




