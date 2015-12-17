//: # Harmonic Oscillator Schrödinger Equation
//: ## Version 2
//:
//: Numerically Solve for Shrödinger's Equation using the
//: [Numerov method](https://en.wikipedia.org/wiki/Numerov%27s_method).
//: This example inspired by Quantum
//: Physics for Dummies, Steven Holzner, Wiley 2013.
//:
//: This version is thousands of times faster and more 
//: accurate than my more direct port of the original.  It starts with
//: a generous step size and when it overshoots
//: turns back the other way at a reduced step size.
//:
//: The first version can be found [here](https://gist.github.com/rayfix/58997f1c6bc8cbae94f8).


import Foundation

public enum ShrödingerEquation {
  private enum StepDirection { case Subtracting, Adding }
  
  public static func calculateGroundState() -> Energy {
    
    // The goal of this algorithm is to step through different energy values
    // and find the value that makes the wave function Psi zero.
    
    
    var psi: WaveFunctionValue = -1.0      // trying to pick a groundState that makes this go to zero
    let MaxPsi: WaveFunctionValue = 1e-9   // stop when the psi is this close to zero
    var direction = StepDirection.Adding   // start off adding
    var step = Energy(MeV: 0.1)            // step size MeV

    var groundState = Energy(MeV: 1)       // initial ground state value
    let stepSizeReductionFactor = 10.0     // reduce the step size by this amount when it overshoots

    while fabs(psi) > MaxPsi {
      if psi > 0 {
        if direction == .Adding {
          print("refining -")
          step.MeV /= stepSizeReductionFactor
        }
        direction = .Subtracting
        groundState.MeV -= step.MeV
      }
      else {
        if direction == .Subtracting {
          print("refining +")
          step.MeV /= stepSizeReductionFactor
        }
        direction = .Adding
        groundState.MeV += step.MeV
      }
      
      let numerovIterations = 200
      psi = ComputePsi.estimate(iterations: numerovIterations, energy: groundState)
      print("Psi\(numerovIterations): \(psi) E: \(groundState.MeV)")
    }

    print("Ground state energy: \(groundState)")
    return groundState
  }
}

//: ### Making it fast.
//: The below code can be placed in a compiled module to make the computation run orders of magnitude faster.

// A simple type for energy

public struct Energy {
  public var MeV: Double
}

extension Energy: CustomStringConvertible {
  public var description: String {
    return "\(MeV) MeV"
  }
}

// A simple type for the values returned by wave function whose absolute
// value is probability / length.
public typealias WaveFunctionValue = Double


//: Psi computation using the [Numerov method](https://en.wikipedia.org/wiki/Numerov%27s_method).
public
enum ComputePsi {
  
  static public func estimate(iterations iterations: Int, energy: Energy) -> WaveFunctionValue {
    
    var sv0 = 0.0
    var sv1 = -0.000000001
    
    for i in 1 ..< iterations {
      let estimate = calculateNextPsi(i, psiMinus1: sv0, psi0: sv1, E: energy.MeV, iterations: iterations)
      sv0 = sv1
      sv1 = estimate
    }
    return sv1
  }
  
  static func calculateKSquared(n: Int, h_0: Double, E: Double) -> Double {
    let x = h_0 * Double(n) - 15
    return (((0.05) * E) -  ((x * x) * 5.63e-3))
  }
  
  static func calculateNextPsi(n: Int, psiMinus1: Double, psi0: Double, E: Double, iterations: Int) -> WaveFunctionValue {
    
    let h_0 = 30 / Double(iterations)
    
    let KSqNMinusOne = calculateKSquared(n-1, h_0: h_0, E: E)
    let KSqN         = calculateKSquared(n, h_0: h_0, E: E)
    let KSqNPlusOne  = calculateKSquared(n+1, h_0: h_0, E: E)
    
    let h_0sq = h_0 * h_0
    
    var nextPsi = 2 * (1 - (5 * h_0sq * KSqN / 12)) * psi0
    nextPsi -= (1 + (h_0sq * KSqNMinusOne / 12)) * psiMinus1
    nextPsi /= 1 + (h_0sq * KSqNPlusOne / 12)
    return nextPsi
  }
}

//: Uncomment the below line to run the algorithm.
ShrödingerEquation.calculateGroundState()



