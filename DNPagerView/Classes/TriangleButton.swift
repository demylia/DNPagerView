//
//  TriangleButton.swift
//  DNPagerView
//
//  Created by Dmitry.Tihonov on 20.09.17.
//  Copyright © 2017 Dmitry.Tihonov. All rights reserved.
//

import UIKit

class TriangleButton: UIButton {
    
    var isOpen = false { didSet { setNeedsDisplay()}}
    
    override func draw(_ rect: CGRect) {
        
        drawTriangleForState(isOpen: isOpen, in: rect)
    }
    
    var previousLayer: CAShapeLayer?
    
    private func drawTriangleForState(isOpen: Bool, in rect: CGRect){
        
        previousLayer?.removeFromSuperlayer()
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.maxX - 0.5, y: rect.minY))
        
        trianglePath.addLine(to: CGPoint(x: rect.maxX + (isOpen ? -10 : 10), y: rect.maxY/2))
        trianglePath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        trianglePath.close()
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = PagerView.controlColor.cgColor
        triangleLayer.position = CGPoint(x: isOpen ? -rect.maxX + 0.5 : 0, y: rect.minY)
        triangleLayer.name = "triangle"
        
        layer.addSublayer(triangleLayer)
        layer.cornerRadius = 3.0
        previousLayer = triangleLayer
    }
}
