//
//  Graph.swift
//  AnimatedChart
//
//  Created by Daniel Henshaw on 29/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class Graph: UIView {
    
    // MARK: - Properties

    var graphProperties: GraphProperties
    var graphView: GraphView?
    var graphBackGround: GraphBackground?

    
    // MARK: - Life cycle
    
    init(frame: CGRect, dataEntries: [CGFloat], yLabelsArray: [String], xLabelsArray: [String]) {
        self.graphProperties = GraphProperties(dataEntries: dataEntries, yLabelsArray: yLabelsArray, xLabelsArray: xLabelsArray)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func setupView() {
        
        let graphBackGroundFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        graphBackGround = GraphBackground(frame: graphBackGroundFrame, graphProperties: graphProperties)
        addSubview(graphBackGround!)
        
        
        let graphViewFrame = CGRect(x: graphProperties.yLabelsWidth,
                                    y: 0,
                                    width: self.frame.width - graphProperties.yLabelsWidth,
                                    height: self.frame.height - graphProperties.xLabelsHeight)
        
        graphView = GraphView(frame: graphViewFrame, graphProperties: graphProperties)
        addSubview(graphView!)
        
        bringSubviewToFront(graphBackGround!)
        
    }
}
