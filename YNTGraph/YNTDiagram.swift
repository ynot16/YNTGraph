//
//  YNTDiagram.swift
//  YNTGraph
//
//  Created by bori－applepc on 2016/10/8.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import Foundation
import UIKit

enum Primitive {
    case Ellipse
    case Rectangle
    case Text(String)
}

enum Attribute {
    case FillColor(UIColor)
}

indirect enum Diagram {
    case Prim(CGSize, Primitive)
    case Beside(Diagram, Diagram)
    case Below(Diagram, Diagram)
    case Attributed(Attribute, Diagram)
    case Align(CGVector, Diagram)
}

extension Diagram {
    var size: CGSize {
        switch self {
            case .Prim(let size, _):
                return size
            case .Attributed(_, let x):
                return x.size
            case .Below(let l, let r):
                return CGSize(width: max(l.size.width, r.size.width), height: l.size.height + r.size.height)
            case .Beside(let l, let r):
                return CGSize(width: l.size.width + r.size.width, height: max(l.size.height, r.size.height))
            case .Align(_, let r):
                return r.size
        }
    }
}

extension Diagram {
    func fill(color: UIColor) -> Diagram {
        return .Attributed(.FillColor(color), self)
    }
    
    func alignTop() -> Diagram {
        return .Align(CGVector(dx: 0.5, dy: -1), self)
    }
    
    func alignBottom() -> Diagram {
        return .Align(CGVector(dx: 0.5, dy: 0), self)
    }
}

func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSize(width: width, height: height), .Rectangle)
}

func sqaure(side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

func circle(diameter: CGFloat) -> Diagram {
    return .Prim(CGSize(width: diameter, height: diameter), .Ellipse)
}

func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSize(width: width, height: height), .Text(theText))
}

infix operator |||
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Beside(l, r)
}

infix operator ---
func --- (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Below(l, r)
}

let empty: Diagram = rect(width: 0, height: 0)
func hcat(diagrams: [Diagram]) -> Diagram {
    return diagrams.reduce(empty, |||)
}

