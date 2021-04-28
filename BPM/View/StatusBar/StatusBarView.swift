//
//  StatusBarView.swift
//  Bpm-iphone
//
//  Created by Keeper on 20/01/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import UIKit

class StatusBarView: UIView {
    
    static let shared = StatusBarView()
    
    var barTintColor: UIColor = .appDarkGray {
        didSet {
            clockView.clockTintColor = barTintColor
            batteryPercentageView.labelTintColor = barTintColor
            batteryIndicator.indicatorTintColor = barTintColor
        }
    }
    
    fileprivate var batteryLevel: Int {
        return Int(UIDevice.current.batteryLevel * 100)
    }
    
    fileprivate let clockView = ClockView()
    fileprivate let batteryPercentageView = BatteryPercentageView()
    fileprivate let batteryIndicator = BatteryIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .gray
        setupSubviews()
        setupObservers()
        batteryLevelDidChange()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupSubviews() {
        addSubview(clockView)
        addSubview(batteryIndicator)
        addSubview(batteryPercentageView)
        
        let leftPadding: CGFloat = ScreenService.shared.isX() ? 27 : 6
        let rightPadding: CGFloat = ScreenService.shared.isX() ? 16 : 4
        
        clockView.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: leftPadding, bottom: 0, right: 0)
        )
        
        clockView.centerInSuperview(axis: Axis(isX: false), offset: CGPoint(x: 0, y: 0))
        
        batteryIndicator.anchor(
            top: nil,
            leading: nil,
            bottom: clockView.bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 2.5, right: rightPadding),
            size: .init(width: 28, height: 14)
        )
        batteryPercentageView.anchor(
            top: nil,
            leading: nil,
            bottom: clockView.bottomAnchor,
            trailing: batteryIndicator.leadingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 2)
        )
        
        clockView.fontSize = 13
        batteryPercentageView.fontSize = 13
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func batteryLevelDidChange() {
        print(batteryLevel)
        batteryPercentageView.level = batteryLevel
        batteryIndicator.level = CGFloat(batteryLevel) / 100
    }
}
