//
//  CG+Extension.swift
//  YNTGraph
//
//  Created by bori－applepc on 2016/10/8.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

extension CGContext {
    func draw(bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
        case .Prim(let size, .Ellipse):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: -0.5), bounds)
            fillEllipse(in: frame)
        case .Prim(let size, .Rectangle):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: -0.5), bounds)
            fill(frame)
        case .Prim(let size, .Text(let text)):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: -0.5), bounds)
            let font = UIFont.systemFont(ofSize: 12)
            let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
            attributedText.draw(in: frame)
        case .Attributed(.FillColor(let color), let d):
            saveGState()
            color.set()
            draw(bounds: bounds, d)
            restoreGState()
        case .Beside(let left, let right):
            let (lFrame, rFrame) = bounds.split(ratio: left.size.width / diagram.size.width, edge: .minXEdge)
            draw(bounds: lFrame, left)
            draw(bounds: rFrame, right)
        case .Below(let top, let bottom):
            let (lFrame, rFrame) = bounds.split(ratio: top.size.height / diagram.size.height, edge: .minYEdge)
            draw(bounds: lFrame, top)
            draw(bounds: rFrame, bottom)
        case .Align(let vec, let diagram):
            let frame = diagram.size.fit(vector: vec, bounds)
            draw(bounds: frame, diagram)
        }
    }
}

func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}

func /(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}

func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}

func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}

func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func +(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGVector {
    var point: CGPoint { return CGPoint(x: dx, y: dy) }
    var size: CGSize { return CGSize(width: dx, height: dy) }
}

extension CGSize {
    func fit(vector: CGVector, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)
        return CGRect(origin: rect.origin - space.point, size: size)
    }
}

extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divided(atDistance: length * ratio, from: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge
    }
}
