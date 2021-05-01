//
//  ViewController.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 09/03/2018.
//  Copyright © 2018 Anton Skvartsou. All rights reserved.
//

import UIKit

struct TempoHandler {
    let sync: Double
    let master: Double
}

class HomeController: BaseController {
    
    internal let onAirView: OnAirView = {
        let view = OnAirView()
        view.deckColor = .appYellow
        return view
    }()
    
    fileprivate var settingsButtonAnchoredConstraints: AnchoredConstraints?
    fileprivate var settingsController: SettingsController?
    fileprivate var settingsControllerView: UIView?
    fileprivate var settingsAnimationDuration: Double = 0.7
    
    fileprivate let decksContainerView = UIView()
    
    fileprivate let leftHintView = HintView()
    fileprivate let rightHintView = HintView()
    
    fileprivate let leftDeckView: BPMDragView = {
        let dragView = BPMDragView(side: .left)
        dragView.deckColor = .appYellow
        return dragView
    }()
    
    fileprivate let rightDeckView: BPMDragView = {
        let dragView = BPMDragView(side: .right)
        dragView.deckColor = .appRed
        return dragView
    }()
    
    fileprivate let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "settings")
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.layer.cornerRadius = 10
        button.backgroundColor = .appDarkGray
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .appWhite
        button.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupDragViewsHandlersAndDelegates()
        setupBottomButton()
    }
    
    fileprivate func setupDragViewsHandlersAndDelegates() {
        leftDeckView.delegate = self
        rightDeckView.delegate = self
        
        leftDeckView.openHandler = { [weak self] (tempo) in
            let tapController = TapController(side: .left)
            tapController.tempo = tempo
            tapController.delegate = self?.leftDeckView
            tapController.modalPresentationStyle = .fullScreen
            self?.present(tapController, animated: true)
        }
        rightDeckView.openHandler = { [weak self] (tempo) in
            let tapController = TapController(side: .right)
            tapController.tempo = tempo
            tapController.delegate = self?.rightDeckView
            tapController.modalPresentationStyle = .fullScreen
            self?.present(tapController, animated: true)
        }
    }
    
    func setupBottomButton() {
        bottomButton.setTitle("MATCH", for: .normal)
        bottomButton.backgroundColor = .appDarkGray
        bottomButton.setTitleColor(.appWhite, for: .normal)
        bottomButton.setTitleColor(.appInactiveWhite, for: .disabled)
        bottomButton.isEnabled = false
    }
    
    override func setupCoverView() {
        coverView.backgroundColor = .appDarkGray
    }

    fileprivate func setupSubviews() {
        view.backgroundColor = .appWhite
        view.addSubview(settingsButton)
        view.addSubview(onAirView)
        view.addSubview(decksContainerView)
        view.addSubview(leftHintView)
        view.addSubview(rightHintView)
        
        let deckWidth = view.frame.width / 2
        let hintViewHeight: CGFloat = 120
        let settingsButtonTopPadding: CGFloat = ScreenService.shared.isX() ? 20 : 44
        
        
        decksContainerView.addSubview(leftDeckView)
        decksContainerView.addSubview(rightDeckView)
        
        onAirView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: decksContainerView.topAnchor,
            trailing: view.trailingAnchor,
            size: Size(width: nil, height: 50)
        )
        
        decksContainerView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.centerYAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -(deckWidth / 2 - 30), right: 0),
            size: Size(width: nil, height: deckWidth)
        )
        
        leftHintView.anchor(
            top: decksContainerView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.centerXAnchor,
            size: Size(width: nil, height: hintViewHeight)
        )
        
        rightHintView.anchor(
            top: decksContainerView.bottomAnchor,
            leading: view.centerXAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            size: Size(width: nil, height: hintViewHeight)
        )
        
        leftDeckView.anchor(
            top: decksContainerView.topAnchor,
            leading: decksContainerView.leadingAnchor,
            bottom: decksContainerView.bottomAnchor,
            trailing: decksContainerView.centerXAnchor
        )
        
        rightDeckView.anchor(
            top: decksContainerView.topAnchor,
            leading: decksContainerView.centerXAnchor,
            bottom: decksContainerView.bottomAnchor,
            trailing: decksContainerView.trailingAnchor
        )
        
        settingsButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: settingsButtonTopPadding, left: 0, bottom: 0, right: 0),
            size: Size(width: 66, height: 52)
        )
    }
    
    fileprivate enum ButtonState {
        case match
        case done
    }
    
    fileprivate var bottomButtonState: ButtonState = .match
    
    override func handleBottomButtonPressed() {
        switch bottomButtonState {
        case .match:
            guard let leftTempo = BPMService.sharedInstance.leftDeckBPM else { return }
            guard let rightTempo = BPMService.sharedInstance.rightDeckBPM else { return }
            let sideOnAir = BPMService.sharedInstance.sideOnAir
            let currentPitchRange = BPMService.sharedInstance.currentPitchRange.rawValue
            
            switch sideOnAir {
            case .left:
                leftHintView.reset()
                rightHintView.matchTempo(
                    leftTempo: Double(leftTempo),
                    rightTempo: Double(rightTempo),
                    sideOnAir: sideOnAir,
                    pitchRange: currentPitchRange
                )
            case .right:
                rightHintView.reset()
                leftHintView.matchTempo(
                    leftTempo: Double(leftTempo),
                    rightTempo: Double(rightTempo),
                    sideOnAir: sideOnAir,
                    pitchRange: currentPitchRange
                )
            }
            
            bottomButton.setTitle("DONE", for: .normal)
            bottomButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            bottomButtonState = .done
        case .done:
            leftHintView.reset()
            rightHintView.reset()
            bottomButton.setTitle("MATCH", for: .normal)
            bottomButton.backgroundColor = .appDarkGray
            bottomButtonState = .match
        }
        
    }
}

extension HomeController: BPMDragViewDelegate {
    
    func didDrag(offset: CGFloat, side: Side) {
        switch side {
        case .left:
            handleHintViewAnimation(leftHintView, offset: offset)
        case .right:
            handleHintViewAnimation(rightHintView, offset: offset)
        }
    }
    
    func didUpdateTempo() {
        leftHintView.reset() // this repeats several times
        rightHintView.reset()
        bottomButton.setTitle("MATCH", for: .normal)
        bottomButton.backgroundColor = .appDarkGray
        bottomButtonState = .match
        
        let leftTempo = BPMService.sharedInstance.leftDeckBPM
        let rightTempo = BPMService.sharedInstance.rightDeckBPM
        
        if leftTempo != nil && rightTempo != nil {
            bottomButton.isEnabled = true
        } else {
            bottomButton.isEnabled = false
        }
    }
    
    func handleHintViewAnimation(_ hintView: UIView, offset: CGFloat) {
        switch true {
        case offset == 0:
            UIView.animate(withDuration: 0.5) {
                hintView.transform = .identity
            }
        case offset > 0:
            hintView.transform = CGAffineTransform(translationX: 0, y: offset)
        default:
            return
        }
    }
}

extension HomeController {
    @objc func handleShowSettings() {
        let controller = SettingsController()
        let settingsView = controller.view!
        controller.dismissHandler = { [weak self] in
            self?.handleHideSettings()
        }
        
        settingsControllerView = settingsView
        settingsController = controller
        view.addSubview(settingsView)
        addChild(controller)
        
        let startingFrame = settingsButton.frame
        settingsButtonAnchoredConstraints = settingsView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil, trailing: nil,
            padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),
            size: .init(width: startingFrame.width, height: startingFrame.height)
        )
        
        settingsControllerView?.layer.maskedCorners = settingsButton.layer.maskedCorners
        settingsControllerView?.layer.cornerRadius = settingsButton.layer.cornerRadius
        settingsControllerView?.clipsToBounds = true
        
        view.layoutIfNeeded()
        
        settingsButtonAnchoredConstraints?.top?.constant     = 0
        settingsButtonAnchoredConstraints?.leading?.constant = 0
        settingsButtonAnchoredConstraints?.width?.constant   = self.view.frame.width
        settingsButtonAnchoredConstraints?.height?.constant  = self.view.frame.height
        
        UIView.animate(
            withDuration: settingsAnimationDuration,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.coverView.alpha = 0.8
                self.settingsControllerView?.layer.cornerRadius = 0
                controller.coverView.alpha = 0
            }
        )
    }
    
    fileprivate func handleHideSettings() {
        settingsButtonAnchoredConstraints?.top?.constant     = settingsButton.frame.origin.y
        settingsButtonAnchoredConstraints?.leading?.constant = settingsButton.frame.origin.x
        settingsButtonAnchoredConstraints?.width?.constant   = settingsButton.frame.width
        settingsButtonAnchoredConstraints?.height?.constant  = settingsButton.frame.height
        
        UIView.animate(
            withDuration: settingsAnimationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.coverView.alpha = 0
                self.settingsController?.imageCoverView.alpha = 1
                self.settingsControllerView?.layer.cornerRadius = self.settingsButton.layer.cornerRadius
            },
            completion: { _ in
                self.settingsControllerView?.removeFromSuperview()
                self.settingsController?.removeFromParent()
            }
        )
    }
}
