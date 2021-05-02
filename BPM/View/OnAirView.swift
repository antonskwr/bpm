//
//  OnAirView.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 23/03/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

protocol OnAirViewDelegate {
    func didChangeSide()
}

class OnAirView: UIView {
    
    public var delegate: OnAirViewDelegate?
    
    let dragThreshold: CGFloat = 60
    let velocityThreshold: CGFloat = 500
    
    var gestureStartPointX = CGFloat()
    
    var canBeDragged = true
    var gestureEnded = true
    
    public var deckColor: UIColor = .clear {
        didSet {
            onAirCircle.tintColor = deckColor
        }
    }
    
    fileprivate let onAirContainer = UIView()
    
    fileprivate let onAirLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.textColor = .appDarkGray
        label.text = "On Air"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let onAirCircle: UIImageView = {
        let circleImage = UIImage(named: "circle")
        let circleView = UIImageView(image: circleImage)
        circleView.image = circleView.image?.withRenderingMode(.alwaysTemplate)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupSubviews() {
        addSubview(onAirContainer)
        onAirContainer.addSubview(onAirLabel)
        onAirContainer.addSubview(onAirCircle)
        
        onAirLabel.centerInSuperview(offset: .init(x: 8, y: 0))
        onAirCircle.centerInSuperview(axis: Axis(isX: false), offset: .init(x: 0, y: -2))
        
        onAirContainer.anchor(
            top: topAnchor,
            leading: nil,
            bottom: bottomAnchor,
            trailing: nil
        )
        
        NSLayoutConstraint.activate([
            onAirContainer.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 1/2
            ),
            onAirCircle.trailingAnchor.constraint(
                equalTo: onAirLabel.leadingAnchor,
                constant: -6
            ),
        ])
    }
    
    fileprivate func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handleDrag(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            handleBegan(gesture)
        case .changed:
            handleChanged(gesture)
        case .ended:
            resetPosition()
        default:
            break
        }
    }
    
    fileprivate func handleBegan(_ gesture: UIPanGestureRecognizer) {
        gestureEnded = false
        gestureStartPointX = gesture.location(in: nil).x
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let point: CGPoint = gesture.location(in: nil)
        let translation = gesture.translation(in: nil)
        let velocity = gesture.velocity(in: nil)
        let rightPosition = self.frame.width / 2
        
        
        if !gestureEnded && canBeDragged {
            let distance = point.x - gestureStartPointX
            print("distance \(distance)")
            
            if distance > dragThreshold
                || (velocity.x > velocityThreshold && BPMService.sharedInstance.sideOnAir == .left) {
                snap(to: .right)
            } else if distance < -dragThreshold
                || (velocity.x < -velocityThreshold && BPMService.sharedInstance.sideOnAir == .right) {
                snap(to: .left)
            } else {
                if onAirContainer.transform.tx > -20 && onAirContainer.transform.tx < (rightPosition + 20) {
                    onAirContainer.transform.tx += translation.x
                    gesture.setTranslation(CGPoint.zero, in: nil)
                } else {
                    gestureEnded = true
                    resetPosition()
                }
            }
        }
    }
    
    fileprivate func snap(to side: Side) {
        if canBeDragged {
            BPMService.sharedInstance.sideOnAir = side
            canBeDragged = false
            let xTransform: CGFloat
            
            switch side {
            case .left:
                xTransform = 0
            case .right:
                xTransform = (self.frame.width / 2)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.onAirContainer.transform.tx = xTransform
                self.deckColor = (side == .left) ? .appYellow : .appRed
            }, completion: { _ in
                self.canBeDragged = true
                self.delegate?.didChangeSide()
            })
        }
    }
    
    fileprivate func resetPosition() {
        snap(to: BPMService.sharedInstance.sideOnAir)
    }
}
