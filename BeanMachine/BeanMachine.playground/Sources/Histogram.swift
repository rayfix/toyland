import UIKit


class HistogramView : UIView {
  
  var histogram: [Int]
  
  init(positions: [Int]) {
    histogram = positions
    super.init(frame: CGRect(x: 0, y: 0, width: 1000, height: 250))
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }
  
  override func drawRect(rect: CGRect) {
    guard !histogram.isEmpty else { return }
    let xStep = frame.width / CGFloat(histogram.count)
    let yScale: CGFloat
    if let largest = histogram.maxElement() where largest > 0 {
      yScale = frame.height * 0.75 / CGFloat(largest)
    }
    else {
      return
    }
    
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
    CGContextFillRect(context, rect)
    
    CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
    for (index, value) in histogram.enumerate() {
      let x = CGFloat(index) * xStep
      let y = CGFloat(value) * yScale
      let bar = CGRect(x: x, y: frame.height-y, width: xStep, height: y)
      CGContextFillRect(context, bar)
    }
  }
}

public struct Results : CustomPlaygroundQuickLookable {
  public var positions: [Int]
  public init(size: Int) {
    positions = Array(count: size, repeatedValue: 0)
  }
  
  public mutating func add(position: Int) {
    let p = min(max(0,position), positions.count-1)
    positions[p] += 1
  }
  
  public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    return PlaygroundQuickLook(reflecting: HistogramView(positions: positions))
  }
}



