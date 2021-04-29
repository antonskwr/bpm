//
//  BatteryPercentageView.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 20/01/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

class BatteryPercentageView: UIView {
    
    var labelTintColor: UIColor = .black {
        didSet {
            batteryPercentageLabel.textColor = labelTintColor
        }
    }
    
    var level: Int? {
        didSet {
            let unwrappedLevel = level ?? 50
            var text = "N/A"
            if unwrappedLevel >= 0 {
                text = "\(unwrappedLevel)%"
            }
            batteryPercentageLabel.text = text
        }
    }
    
    var fontSize: CGFloat = 12 {
        didSet {
            batteryPercentageLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        }
    }
    
    fileprivate let batteryIndicatorView = UIView()
    
    fileprivate lazy var batteryPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "\(level ?? 50)%"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupSubviews() {
        addSubview(batteryPercentageLabel)
        batteryPercentageLabel.fillSuperview()
    }
}
