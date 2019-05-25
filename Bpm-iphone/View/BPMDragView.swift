//
//  BPMDragView.swift
//  Bpm-iphone
//
//  Created by Keeper on 23/03/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import UIKit

enum Side {
    case left, right
}

protocol BPMDragViewDelegate {
    func didDrag(offset: CGFloat, side: Side)
}

class BPMDragView: UIView {
    
    public var delegate: BPMDragViewDelegate?
    fileprivate var side: Side
    fileprivate var deckCanBeDragged = false
    
    public var hintViewVerticalOffset: CGFloat = 0 {
        didSet {
            delegate?.didDrag(offset: hintViewVerticalOffset, side: side)
        }
    }
    
    public var deckColor: UIColor? {
        didSet {
            deckView.backgroundColor = deckColor
        }
    }
    
    fileprivate var tempoValue: Int? {
        didSet {
            switch side {
            case .left:
                BPMService.sharedInstance.leftDeckBPM = tempoValue
            case .right:
                BPMService.sharedInstance.rightDeckBPM = tempoValue
            }
            
            if let tempoValue = tempoValue {
                bpmLabel.text = String(tempoValue)
            } else {
                bpmLabel.text = "-/-"
            }
        }
    }
    
    public var openHandler: ((Int?) -> Void)?
    
    fileprivate let deckView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let deckUnderView: UIView = {
        let view = UIView()
        view.backgroundColor = .appDarkGray
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let lock: UIImageView = {
        let screenWidth = UIScreen.main.bounds.width / 2
        let lockImage = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
        let lock = UIImageView(image: lockImage)
        lock.tintColor = .appWhite
        lock.center = CGPoint(x: screenWidth / 2, y: -20)
        return lock
    }()
    
    fileprivate let bpmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 40)
        label.text = "-/-"
        //        label.textColor = .appWhite
        label.textColor = .appDarkGray
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let bpmText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        label.text = "BPM"
        //        label.textColor = .appWhite
        label.textColor = .appDarkGray
        label.textAlignment = .center
        return label
    }()
    
    init(side: Side) {
        self.side = side
        super.init(frame: .zero)
        setupSubviews()
        setupGestureRecognizer()
        adaptToScreenSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    fileprivate func setupSubviews() {
        addSubview(deckUnderView)
        addSubview(deckView)
        
        deckUnderView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 20, right: 0)
        )
        
        deckView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil)
        
        deckView.anchorSizeTo(self)
        
        deckUnderView.addSubview(lock)
        deckView.addSubview(bpmLabel)
        deckView.addSubview(bpmText)
        
        bpmLabel.centerInSuperview()
        bpmText.centerInSuperview(offset: .init(x: 0, y: 50))
        
        
        lock.anchor(
            top: nil,
            leading: nil,
            bottom: deckUnderView.topAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 0, bottom: -30, right: 0)
        )
        
        lock.centerInSuperview(axis: Axis(isX: true))
    }
    
    fileprivate func adaptToScreenSize() {
        switch ScreenService.shared.getSize() {
        case .iPhoneSE:
            bpmLabel.font = UIFont(name: "AvenirNext-Bold", size: 36)
        default:
            break
        }
    }
    
    fileprivate func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDeckDrag))
        deckView.addGestureRecognizer(panGesture)
    }
    
    @objc func handleDeckDrag(_ gesture: UIPanGestureRecognizer) {
        var translation = gesture.translation(in: nil)
        var velocity = gesture.velocity(in: nil)
        
        func handleChange() {
            if deckCanBeDragged {
                if deckView.transform.ty > -5 {
                    if translation.y > -15 {
                        moveDeck(translationY: translation.y)
                    } else {
                        translation.y = -15
                        moveDeck(translationY: translation.y)
                    }
                } else {
                    resetPosition()
                    return
                }

                if deckView.transform.ty > 120 {
                    openHandler?(tempoValue)
                    resetPosition()
                    return
                }
            }
        }
        
        switch gesture.state {
        case .began:
            if velocity.y > 0 {
                deckCanBeDragged = true
            } else {
                deckCanBeDragged = false
            }
        case .changed:
            handleChange()
        case .cancelled:
            resetPosition()
        case .ended:
            resetPosition()
        default:
            break
        }
    }
    
    fileprivate func moveDeck(translationY: CGFloat) {
        deckView.transform.ty = translationY
        lock.transform.ty = translationY * 0.35
        hintViewVerticalOffset = translationY
    }
    
    fileprivate func resetPosition() {
        deckCanBeDragged = false
        hintViewVerticalOffset = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.deckView.transform = .identity
            self.lock.transform = .identity
        })
    }
}

extension BPMDragView: TapControllerDelegate {
    func setTempo(_ value: Int?) {
        tempoValue = value
    }
}
