//
//  ClockView.swift
//  Bpm-iphone
//
//  Created by Keeper on 20/01/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    var clockTintColor: UIColor = .black {
        didSet {
           currentTimeLabel.textColor = clockTintColor
        }
    }
    
    var fontSize: CGFloat = 12 {
        didSet {
            currentTimeLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        }
    }
    
    fileprivate var timer = Timer()
    fileprivate let dateFormatter = DateFormatter()
    
    fileprivate lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .red
        setupVariables()
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func setupSubviews() {
        addSubview(currentTimeLabel)
        currentTimeLabel.fillSuperview()
    }
    
    fileprivate func setupVariables() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        dateFormatter.dateFormat = "HH:mm"
    }
    
    @objc fileprivate func tick() {
        currentTimeLabel.text = dateFormatter.string(from: Date())
    }
}
