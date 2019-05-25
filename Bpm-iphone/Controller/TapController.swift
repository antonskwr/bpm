//
//  TapController.swift
//  Bpm-iphone
//
//  Created by Keeper on 10/03/2018.
//  Copyright © 2018 Keeper. All rights reserved.
//

import UIKit

protocol TapControllerDelegate {
    func setTempo(_ value: Int?)
}

class TapController: BaseController {
    
    public var delegate: TapControllerDelegate?
    
    public var tempo: Int? {
        didSet {
            if let tempo = tempo {
                bpmLabel.text = String(tempo)
            } else {
                bpmLabel.text = "-/-"
            }
        }
    }
    
    fileprivate let bpmCounter = BPMCounter()
    fileprivate var initialTap = true
    
    fileprivate let warningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 36)
        label.textColor = .appDarkGray
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate let bpmLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 56)
        label.textColor = .appDarkGray
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let tapTextLabel = UILabel(
        text: "TAP",
        font: UIFont(name: "AvenirNext-Bold", size: 26),
        color: .appDarkGray
    )
    
    fileprivate let toMeasureBRMTextLabel = UILabel(
        text: "to measure BPM",
        font: UIFont(name: "AvenirNext-DemiBold", size: 13),
        color: .appDarkGray
    )
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.setTitleColor(.appDarkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return button
    }()
    
    fileprivate let fullscreenTapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1977257853), forState: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapBPM), for: .touchUpInside)
        return button
    }()
    
    fileprivate var isDisplayingWarning = false {
        didSet {
            bpmLabel.isHidden = isDisplayingWarning
            tapTextLabel.isHidden = isDisplayingWarning
            toMeasureBRMTextLabel.isHidden = isDisplayingWarning
            warningLabel.isHidden = !isDisplayingWarning
        }
    }
    
    init(side: Side) {
        super.init()
        setupWarning(for: side)
        
        switch side {
        case .left:
            view.backgroundColor = .appYellow
        case .right:
            view.backgroundColor = .appRed
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupBottomButton()
    }

    internal func setupBottomButton() {
        bottomButton.setTitle("DONE", for: .normal)
        bottomButton.backgroundColor = .appDarkGray
        bottomButton.setTitleColor(.appWhite, for: .normal)
        //            bottomButton.backgroundColor = .appWhite
        //            bottomButton.setTitleColor(.appDarkGray, for: .normal)
    }
    
    override internal func handleBottomButtonPressed() {
        delegate?.setTempo(tempo)
        dismiss(animated: true)
    }
    
//    fileprivate func setupWarning(_ isLeft: Bool) {
//        if BPMService.sharedInstance.isLeftDeckOnAir && !isLeft {
//            isDisplayingWarning = true
//            warningLabel.text =  "RESET RIGHT DECK PITCH"
//        } else if !BPMService.sharedInstance.isLeftDeckOnAir && isLeft {
//            isDisplayingWarning = true
//            warningLabel.text =  "RESET LEFT DECK PITCH"
//        }
//    }
    
    fileprivate func setupWarning(for deckSide: Side) {
        switch BPMService.sharedInstance.sideOnAir {
        case .left:
            if deckSide == .right {
                isDisplayingWarning = true
                warningLabel.text =  "RESET RIGHT DECK PITCH"
            }
        case .right:
            if deckSide == .left {
                isDisplayingWarning = true
                warningLabel.text =  "RESET LEFT DECK PITCH"
            }
        }
    }
    
    fileprivate func setupSubviews() {
        view.insertSubview(fullscreenTapButton, belowSubview: bottomButton)
        view.insertSubview(tapTextLabel, belowSubview: fullscreenTapButton)
        view.insertSubview(toMeasureBRMTextLabel, belowSubview: fullscreenTapButton)
        view.insertSubview(bpmLabel, belowSubview: fullscreenTapButton)
        view.insertSubview(warningLabel, belowSubview: fullscreenTapButton)
        view.addSubview(cancelButton)
        
        fullscreenTapButton.fillSuperview()
        warningLabel.centerInSuperview(axis: Axis(isX: true))
        bpmLabel.centerInSuperview(offset: CGPoint(x: 0, y: -20))
        toMeasureBRMTextLabel.centerInSuperview(axis: Axis(isX: true))
        tapTextLabel.centerInSuperview(axis: Axis(isX: true))
        
        warningLabel.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.centerYAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20)
        )
        
        toMeasureBRMTextLabel.anchor(
            top: nil,
            leading: nil,
            bottom: bpmLabel.topAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 0, bottom: 16, right: 0)
        )
        
        tapTextLabel.anchor(
            top: nil,
            leading: nil,
            bottom: toMeasureBRMTextLabel.topAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 0, bottom: -4, right: 0)
        )
        
        let cancelButtonTopPadding: CGFloat = ScreenService.shared.isX() ? 10 : 30
        cancelButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(
                top: cancelButtonTopPadding,
                left: 20,
                bottom: 0,
                right: 0
            )
        )
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func tapBPM() {
        if isDisplayingWarning {
            isDisplayingWarning = false
        }
        
        let value = bpmCounter.tapTempo()
        
        if value == nil {
            tempo = nil
        } else {
            tempo = Int(value!)
        }
    }
}
