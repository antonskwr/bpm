//
//  SettingsController.swift
//  Bpm-iphone
//
//  Created by Keeper on 10/03/2018.
//  Copyright © 2018 Keeper. All rights reserved.
//

import UIKit

class SettingsController: BaseController {
    
    public var dismissHandler: (() -> Void)?
    fileprivate var didTapInsideCell = false
    
    fileprivate let topHintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textColor = .appWhite
        label.text = "Select pitch range"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBottomButton()
        hightlightCurrentRangeCell()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .appDarkGray
        view.addSubview(stackView)
        view.addSubview(topHintLabel)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        [PitchRange.eight, .ten, .sixteen, .twenty, .fifty].forEach { (pitchRange) in
            let label = createPitchRangeSelectorCell(pitchRange: pitchRange)
            stackView.addArrangedSubview(label)
        }
        
        topHintLabel.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 68).isActive = true
        topHintLabel.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.topAnchor, constant: -42).isActive = true
        topHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.bringSubviewToFront(coverView)
    }
    
    func setupBottomButton() {
        bottomButton.backgroundColor = .appWhite
        bottomButton.setTitle("DONE", for: .normal)
        bottomButton.setTitleColor(.appDarkGray, for: .normal)
    }
    
    override func setupCoverView() {
        view.addSubview(imageCoverView)
        imageCoverView.fillSuperview()
    }
    
    public let imageCoverView: UIView = {
        let container = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .appWhite
        container.addSubview(imageView)
        imageView.centerInSuperview()
        container.backgroundColor = .appDarkGray
        container.isUserInteractionEnabled = false
        container.alpha = 0
        return container
    }()
    
    @objc override func handleBottomButtonPressed() {
        dismissHandler?()
    }
    
    fileprivate func handleGestureTap(point: CGPoint) {
        let hitTestView = stackView.hitTest(point, with: nil)
        handleCellSelection(hitTestView: hitTestView)
    }
    
    fileprivate func handleGestureDrag(point: CGPoint) {
        guard didTapInsideCell else { return }
        let fixedXLocation = CGPoint(x: stackView.frame.width / 2, y: point.y)
        let hitTestView = stackView.hitTest(fixedXLocation, with: nil)
        handleCellSelection(hitTestView: hitTestView)
    }
    
    fileprivate func handleCellSelection(hitTestView: UIView?) {
        if let cell = hitTestView as? SettingsContainerCell {
            didTapInsideCell = true
            let filteredSubviews = stackView.arrangedSubviews.filter { (subview) -> Bool in
                return subview !== cell
            }
            
            filteredSubviews.forEach { subview in
                guard let v = subview as? SettingsContainerCell else { return }
                v.setUnhiglighted()
            }
            
            cell.setHiglighted()
            setPitchRange(cell.pitchRange)
            
            UIView.animate(withDuration: 0.3) {
                filteredSubviews.forEach { subview in
                    guard let subview = subview as? SettingsContainerCell else { return }
                    subview.transform = .identity
                }
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }
    }
    
    fileprivate func createPitchRangeSelectorCell(pitchRange: PitchRange) -> UIView {
        let cellOptionView = SettingsContainerCell(pitchRange: pitchRange)
        cellOptionView.anchorSize(size: Size(width: nil, height: 70))
        return cellOptionView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: stackView)
            handleGestureTap(point: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: stackView)
            handleGestureDrag(point: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didTapInsideCell = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        didTapInsideCell = false
    }
}


extension SettingsController {
    fileprivate func setPitchRange(_ pitchRange: PitchRange) {
        BPMService.sharedInstance.currentPitchRange = pitchRange
    }
    
    fileprivate func hightlightCurrentRangeCell() {
        guard let pitchCells = stackView.arrangedSubviews as? [SettingsContainerCell] else { return }
        let currentPitchCell = pitchCells.first { (cell) -> Bool in
            return cell.pitchRange == BPMService.sharedInstance.currentPitchRange
        }
        
        currentPitchCell?.setHiglighted()
    }
}

