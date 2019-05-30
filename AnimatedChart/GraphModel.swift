//
//  GraphModel.swift
//  AnimatedChart
//
//  Created by Daniel Henshaw on 30/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

/*
 The GraphModel currently contains all the data that is required to build the graph.
 Most of the values have default values and the user only needs to provide the data entries, y- and x-axis labels.
*/

import UIKit

class GraphProperties {
    
    let dataEntries: [CGFloat]
    let yLabelsArray: [String]
    let xLabelsArray: [String]
    
    var yLabelsWidth: CGFloat = 150
    var xLabelsHeight: CGFloat = 30
    
    var shouldFill: Bool = true
    var shouldAnimate: Bool = true
    
    var frequency: CGFloat = 4
    var amplitude: CGFloat = 3
    
    let fadedWhiteColour: UIColor = UIColor(white: 1.0, alpha: 0.7)
    
    init(dataEntries: [CGFloat], yLabelsArray: [String], xLabelsArray: [String]) {
        self.dataEntries = dataEntries
        self.yLabelsArray = yLabelsArray
        self.xLabelsArray = xLabelsArray
    }
}
