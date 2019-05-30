//
//  ViewController.swift
//  AnimatedChart
//
//  Created by Daniel Henshaw on 28/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var graphView: Graph?
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .blue
        loadNewGraph()
    }
    
    
    // MARK: - Actions
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        graphView?.removeFromSuperview()
        loadNewGraph()
    }
    
    @objc func loadNewGraph() {
        let margin: CGFloat = 50
        let frame = CGRect(x: margin, y: margin, width: view.frame.width - margin * 2, height: view.frame.height - margin * 2)
        let yLabelsArray = ["HEAVY", "MED", "LOW"]
        let xLabelsArray = ["NOW", "15", "30", "45", "60"]
        let dataEntries = generateRandomEntries()
        graphView = Graph(frame: frame, dataEntries: dataEntries, yLabelsArray: yLabelsArray, xLabelsArray: xLabelsArray)
        view.addSubview(graphView!)
    }
    
    // MARK: - Helpers
    
    private func generateRandomEntries() -> [CGFloat] {
        var result: [CGFloat] = []
        for _ in 0 ..< 10 {
            let value = CGFloat.random(in: 50 ... 90)
            result.append(value)
        }
        return result
    }

}
