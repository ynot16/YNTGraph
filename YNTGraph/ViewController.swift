//
//  ViewController.swift
//  YNTGraph
//
//  Created by bori－applepc on 2016/10/8.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cities = [
            ("上海", 14.01),
            ("广州", 13.3),
            ("北京", 10.56),
            ("深圳", 8.33),
            ("杭州", 3.43)
        ]
        let example = barGraph(input: cities)
        let diagram = YNTGraphView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 350), diagram: example)
        view.addSubview(diagram)
        // Do any additional setup after loading the view, typically from a nib.
    }
}

func barGraph(input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map { CGFloat($0.1) }
    let nValues = values.normalize()
    let bars = hcat(diagrams: nValues.map { x in
        return rect(width: 1, height: 3 * x).fill(color: .black).alignBottom()
    })
    let labels = hcat(diagrams: input.map { x in
        return text(theText: x.0, width: 1, height: 0.3).alignTop()
    })
    return bars --- labels
}

extension Sequence where Self.Iterator.Element == CGFloat {
    func normalize() -> [CGFloat] {
        let maxVal = self.reduce(0) { (x, y) -> CGFloat in
            return x > y ? x : y
        }
        return self.map { $0 / maxVal }
    }
}
