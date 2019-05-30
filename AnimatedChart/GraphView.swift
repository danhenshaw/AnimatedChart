//
//  GraphView.swift
//  AnimatedChart
//
//  Created by Daniel Henshaw on 29/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

struct CurvedSegment {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}

class GraphView: UIView {
    
    // MARK: - Properties
    
    private let graphProperties: GraphProperties
    
    
    /// displayLink and startTime are used to determine the point in time required for the animations

    private var displayLink: CADisplayLink?
    private var startTime: CFAbsoluteTime?
    
    
    /// dataPoints are the actual values and currentAnimationsPoints represents the current state of the graph.
    
    private var dataPoints: [CGPoint]?
    private var currentAnimationPoints: [CGPoint]?
    
    
    /// The `CAShapeLayer` that will contain the animated path
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    
    // MARK: - Life cycle
    
    init(frame: CGRect, graphProperties: GraphProperties) {
        self.graphProperties = graphProperties
        super.init(frame: frame)
        self.dataPoints = convertDataEntriesToPoints(graphProperties.dataEntries)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopDisplayLink()
    }
    
    override open func draw(_ rect: CGRect) {
        shapeLayer.fillColor = graphProperties.shouldFill == true ? UIColor.red.cgColor : UIColor.clear.cgColor
        shapeLayer.strokeColor = graphProperties.shouldFill == true ? UIColor.clear.cgColor : UIColor.white.cgColor
        shapeLayer.lineWidth = graphProperties.shouldFill == true ? 0 : 3
        shapeLayer.frame = rect
        layer.addSublayer(shapeLayer)
        
        if graphProperties.shouldAnimate {
            self.startDisplayLink()
        } else {
            shapeLayer.path = self.staticChart().cgPath
        }
    }
    
    
    // MARK: - Actions
    
    
    /// Handle the display link timer.
    ///
    /// - Parameter displayLink: The display link.
    
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime!
        shapeLayer.path = waveAnimation(at: elapsed).cgPath
    }
    
    
    // MARK: - Helpers

    
    /// Start the display link
    
    private func startDisplayLink() {
        startTime = CFAbsoluteTimeGetCurrent()
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }

    
    /// Stop the display link
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    

    /// Create the wave animation at a given elapsed time.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.
    
    private func waveAnimation(at elapsed: Double) -> UIBezierPath {
        
        if currentAnimationPoints == nil {
            currentAnimationPoints = dataPoints
        }

        func f(_ point: CGPoint) -> CGPoint {
            var returnValue = CGPoint()
            returnValue.x = point.x
            returnValue.y = point.y + (sin(((point.x / shapeLayer.bounds.width) + CGFloat(elapsed)) * graphProperties.frequency * .pi) * graphProperties.amplitude)
            return returnValue
        }
        
        let path = UIBezierPath()
        
        if let dataPoints = dataPoints {
            path.move(to: currentAnimationPoints![0])
            
            var curveSegments = controlPointsFrom(points: currentAnimationPoints!)
            
            for i in 0 ..< dataPoints.count {
                if i == 0 {
                    path.addLine(to: dataPoints[i])
                } else if i == dataPoints.count - 1 {
                    path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
                } else {
                    currentAnimationPoints![i] = f(dataPoints[i])
                    path.addCurve(to: currentAnimationPoints![i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
                }
            }
        }
        return path
    }
    
    
    /// Build a chart that does not animate
    ///
    /// - Returns: The `UIBezierPath` for a particular point of time.
    
    private func staticChart() -> UIBezierPath {
        
        let path = UIBezierPath()
        if let dataPoints = dataPoints {
            path.move(to: dataPoints[0])
            
            var curveSegments = controlPointsFrom(points: dataPoints)
            
            for i in 0 ..< dataPoints.count {
                if i == 0 || i == dataPoints.count - 1 {
                    path.addLine(to: dataPoints[i])
                } else {
                    path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
                }
            }
        }
        return path
    }
    
    
    /// Create the loading animation at a given elapsed time.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.
    /// - TODO: Currently the animation raises the chart from zero to the correct values. The animation is not complete and still work in progress

    private func springLoadingAnimation(at elapsed: Double) -> UIBezierPath {

        if currentAnimationPoints == nil {
            currentAnimationPoints = [CGPoint]()
            if let dataPoints = dataPoints {
                for point in dataPoints {
                    let startingY: CGFloat = self.frame.height
                    let startingX = point.x
                    currentAnimationPoints!.append(CGPoint(x: startingX, y: startingY))
                }
            }
        }

        let path = UIBezierPath()

        func f(_ point: CGPoint, index: Int) -> CGPoint {

            var returnValue = CGPoint()
            returnValue.x = point.x

            let animationElapsedTime = elapsed
            let changeInY = dataPoints![index].y - point.y

            // t is in the range of 0 to 1, indicates how far through the animation it is.
            let t = animationElapsedTime / 3
            let p = 0.6
            let interpolation = pow(2,-10*t) * sin((t-p/4)*(2*Double.pi)/p) + 1
            returnValue.y = point.y + changeInY * CGFloat(interpolation)

            return returnValue
        }


        if let currentAnimationPoints = currentAnimationPoints {

            path.move(to: currentAnimationPoints[0])

            var curveSegments = controlPointsFrom(points: currentAnimationPoints)

            for i in 0 ..< currentAnimationPoints.count {
                if i == 0 || i == currentAnimationPoints.count - 1 {
                    path.addLine(to: currentAnimationPoints[i])
                } else {
                    self.currentAnimationPoints![i] = f(currentAnimationPoints[i], index: i)
                    path.addCurve(to: currentAnimationPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
                }
            }
        }
        return path
    }


    
    
    
    
    
    
    
    
    
    /// Calculate control points to calculate the cure of the graph.
    ///
    /// - Parameter points: Data points used on the graph
    /// - Returns: An array of CurvedSegment which contains the left and right reference point to calculate the curve
    
    
    private func controlPointsFrom(points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []
        
        let delta: CGFloat = 0.3 // The value that help to choose temporary control points.
        
        // Calculate temporary control points, these control points make Bezier segments look straight and not curving at all
        for i in 1..<points.count {
            let A = points[i-1]
            let B = points[i]
            let controlPoint1 = CGPoint(x: A.x + delta*(B.x-A.x), y: A.y + delta*(B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta*(B.x-A.x), y: B.y - delta*(B.y - A.y))
            let curvedSegment = CurvedSegment(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }
        
        // Calculate good control points
        for i in 1..<points.count-1 {
            /// A temporary control point
            let M = result[i-1].controlPoint2
            
            /// A temporary control point
            let N = result[i].controlPoint1
            
            /// central point
            let A = points[i]
            
            /// Reflection of M over the point A
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)
            
            /// Reflection of N over the point A
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)
            
            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x)/2, y: (MM.y + N.y)/2)
            result[i-1].controlPoint2 = CGPoint(x: (NN.x + M.x)/2, y: (NN.y + M.y)/2)
        }
        
        return result
    }
    
    
    
    /// Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
    ///
    /// - Parameter entries: Data entries supplied by the user.
    /// - Returns: An array of CGPoint
    /// - TODO: Current calculations assumes parameters are percentages. This should be optional.
    
    
    private func convertDataEntriesToPoints(_ entries: [CGFloat]) -> [CGPoint] {
        
        let semaphore = DispatchSemaphore(value: 1)
        var result: [CGPoint] = []

        let lineGap = (self.frame.size.width) / (CGFloat(entries.count) - 1)
        
        if graphProperties.shouldFill {
            let point = CGPoint(x: 0, y: self.frame.height)
            result.append(point)
        }
        
        for i in 0 ..< entries.count {
            let height = self.frame.height * (1 - (entries[i] / 100))
            let point = CGPoint(x: CGFloat(i) * lineGap, y: height)
            result.append(point)
            if i == entries.count - 1 {
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        if graphProperties.shouldFill {
            let point = CGPoint(x: self.frame.width, y: self.frame.height)
            result.append(point)
        }
        return result
    }
}
