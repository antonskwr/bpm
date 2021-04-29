//
//  BatteryIndicatorView.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 20/01/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

class BatteryIndicatorView: UIView {
    
    let batteryLayer = CAShapeLayer()
    let levelLayer = CAShapeLayer()
    
    var indicatorTintColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var level: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(batteryLayer)
        layer.addSublayer(levelLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setup() {
        let batteryHeadWidth: CGFloat = 3
        
        let batteryFrame = CGRect(
            origin: .zero,
            size: bounds.insetBy(
                dx: batteryHeadWidth / 2,
                dy: 0
                ).size
        )
        //        let batteryFrame = bounds
        batteryLayer.frame = batteryFrame
        levelLayer.frame = batteryFrame
        
        let path = CGMutablePath()
        let radius: CGFloat = 3
        let batteryBodyPath = UIBezierPath(
            roundedRect: batteryFrame,
            cornerRadius: radius
        )
        
        let batteryHeadInset: CGFloat = 3
        let batteryHeadRect = CGRect.init(
            x: batteryFrame.width,
            y: batteryHeadInset,
            width: batteryHeadWidth,
            height: batteryFrame.height - batteryHeadInset * 2
        )
        
        let batteryHead = UIBezierPath(
            roundedRect: batteryHeadRect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: .init(width: 2, height: 2)
        )
        
        let negativeSpace = UIBezierPath(
            roundedRect: batteryFrame.insetBy(dx: 2, dy: 2),
            cornerRadius: 2)
        
        path.addPath(batteryBodyPath.cgPath)
        path.addPath(batteryHead.cgPath)
        path.addPath(negativeSpace.cgPath)
        
        batteryLayer.path = path
        batteryLayer.lineWidth = 0
        batteryLayer.fillColor = indicatorTintColor.cgColor
        batteryLayer.fillRule = .evenOdd
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = indicatorTintColor.cgColor
        
        let maskPath = UIBezierPath(
            roundedRect: batteryFrame.insetBy(dx: 3, dy: 3),
            cornerRadius: 2)
        
        maskLayer.path = maskPath.cgPath
        
        
        let pathLevel = UIBezierPath()
        pathLevel.move(to: .init(x: 0, y: batteryFrame.midY))
        pathLevel.addLine(to: .init(x: batteryFrame.width, y: batteryFrame.midY))
        levelLayer.strokeColor = indicatorTintColor.cgColor
        levelLayer.path = pathLevel.cgPath
        levelLayer.lineWidth = batteryFrame.height
        levelLayer.mask = maskLayer
        levelLayer.strokeEnd = level
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
}
