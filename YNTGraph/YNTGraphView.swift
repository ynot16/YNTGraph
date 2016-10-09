//
//  YNTGraphView.swift
//  YNTGraph
//
//  Created by bori－applepc on 2016/10/9.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class YNTGraphView: UIView {
    
    let diagram: Diagram
    
    init(frame: CGRect, diagram: Diagram) {
        self.diagram = diagram
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let ctx = UIGraphicsGetCurrentContext() else {
            print("ctx is nil")
            return
        }
        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.draw(bounds: bounds, diagram)
    }
}
