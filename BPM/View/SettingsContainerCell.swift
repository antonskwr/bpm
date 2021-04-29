//
//  SettingsContainerCell.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 09/05/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

class SettingsContainerCell: UIView {
    
    public let pitchRange: PitchRange
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        return label
    }()
    
    init(pitchRange: PitchRange) {
        self.pitchRange = pitchRange
        super.init(frame: .zero)
        setupLabel(text: pitchRange.description)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setHiglighted() {
        label.backgroundColor = .appWhite
        label.textColor = .appDarkGray
    }
    
    func setUnhiglighted() {
        label.backgroundColor = .clear
        label.textColor = .appWhite
    }
    
    fileprivate func setupLabel(text: String) {
        addSubview(label)
        label.text = text
        label.centerInSuperview(size: Size(width: 130, height: 55), axis: Axis(isX: false))
        label.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
}
