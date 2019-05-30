//
//  GraphBackground.swift
//  AnimatedChart
//
//  Created by Daniel Henshaw on 9/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit


class GraphBackground: UIView {
    
    // MARK: - Properties

    private let graphProperties: GraphProperties
    
    
    // MARK: - Life cycle

    init(frame: CGRect, graphProperties: GraphProperties) {
        self.graphProperties = graphProperties
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func draw(_ rect: CGRect) {
        self.drawGraph(rect)
        self.drawXAxisLabels(rect)
        self.drawYAxisLabels(rect)
    }
    
    
    // MARK: - Helpers
    
    
    /// Draw horizontal lines at equal intervals to form the graph background.
    ///
    /// - TODO: Will give user more options to add vertical lines and choose intervals.

    fileprivate func drawGraph(_ rect: CGRect) {

        let width = rect.width
        let height = rect.height

        let linePath = UIBezierPath()
        
        for index in 1 ..< graphProperties.yLabelsArray.count {
            let yEndPoint = (height - graphProperties.xLabelsHeight) / CGFloat(graphProperties.yLabelsArray.count) * CGFloat(index)
            linePath.move(to: CGPoint(x: 0, y: yEndPoint))
            linePath.addLine(to: CGPoint(x: width, y: yEndPoint))
        }

        graphProperties.fadedWhiteColour.setStroke()
        linePath.lineWidth = 0.5
        linePath.stroke()

        // X axis line
        let baseLine = UIBezierPath()
        baseLine.move(to: CGPoint(x: 0, y: height - graphProperties.xLabelsHeight))
        baseLine.addLine(to: CGPoint(x: width, y: height - graphProperties.xLabelsHeight))

        // Add stroke to X axis
        let bottomColor: UIColor!
        bottomColor = graphProperties.fadedWhiteColour
        bottomColor.setStroke()
        baseLine.lineWidth = 2.0
        baseLine.stroke()
    }


    /// Draw the x-axis labels at the bottom of the graph.
    ///
    /// - TODO: Option of removing x-axis labels. Add x-axis labels to top as well
    
    fileprivate func drawXAxisLabels(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let linePath = UIBezierPath()
        
        for index in 0 ..< graphProperties.xLabelsArray.count {
            let xPosition = graphProperties.yLabelsWidth + ((width - graphProperties.yLabelsWidth) / CGFloat(graphProperties.xLabelsArray.count - 1) * CGFloat(index))
            let yPosition = height - graphProperties.xLabelsHeight
            linePath.move(to: CGPoint(x: xPosition, y: yPosition))
            linePath.addLine(to: CGPoint(x: xPosition, y: yPosition + 5))
            
            let label = UILabel()
            label.text = graphProperties.xLabelsArray[index]
            label.sizeToFit()
            label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.thin)
            label.textColor = graphProperties.fadedWhiteColour
            label.center = CGPoint(x: xPosition, y: height - (graphProperties.xLabelsHeight / 2))
            label.textAlignment = .center
            addSubview(label)
        }
        
        graphProperties.fadedWhiteColour.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()

    }
    
    
    /// Draw the y-axis labels to the left of the graph.
    ///
    /// - TODO: Option of removing y-axis labels. Add y-axis labels to the right as well

    fileprivate func drawYAxisLabels(_ rect: CGRect) {

        let height = rect.height
        
        for index in 0 ..< graphProperties.yLabelsArray.count {
            
            let labelHeight: CGFloat = (height - graphProperties.xLabelsHeight) / CGFloat(graphProperties.yLabelsArray.count)
            
            let label = UILabel(frame: CGRect(x: CGFloat(8), y: labelHeight * CGFloat(index), width: graphProperties.yLabelsWidth - 8, height: labelHeight))
            
            label.text = graphProperties.yLabelsArray[index]
            label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.thin)
            label.textColor = graphProperties.fadedWhiteColour
            addSubview(label)
        }
    }
}
