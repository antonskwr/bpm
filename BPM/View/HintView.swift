//
//  HintView.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 15/05/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

class HintView: UIView {
    
    fileprivate let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textAlignment = .center
        label.textColor = .appDarkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = true
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
        addSubview(hintLabel)
        hintLabel.fillSuperview()
    }
}

extension HintView {
    
    fileprivate func hintOutOfRange() { hint(NSAttributedString(string: "OUT OF RANGE")) }
    
    fileprivate func composeHintText(_ value: Double) {
        let percents = value * 100
        let percentsText = String(format: "%.1f", percents)
        // Maybe this is too much, and just use 2 separate labels
        let hintText = NSMutableAttributedString(
            string: "PITCH\n",
            attributes: [.font: UIFont(name: "AvenirNext-Bold", size: 36)!]
        )
        
        if value > 0 {
            hintText.append(NSAttributedString(string: "+\(percentsText)%", attributes: nil))
        } else {
            hintText.append(NSAttributedString(string: "\(percentsText)%", attributes: nil))
        }
        
        hint(hintText)
    }
    
    fileprivate func hint(_ string: NSAttributedString) {
        self.hintLabel.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.hintLabel.alpha = 1
            self.hintLabel.attributedText = string
        }
    }
    
    public func reset() {
        UIView.animate(withDuration: 0.3) {
            self.hintLabel.alpha = 0
        }
    }
    
    public func matchTempo(leftTempo: Double, rightTempo: Double, sideOnAir: Side, pitchRange: Double) -> Bool {
        
        let tempo: TempoHandler
        switch sideOnAir {
        case .left:
            tempo = TempoHandler(sync: rightTempo, master: leftTempo)
        case .right:
            tempo = TempoHandler(sync: leftTempo, master: rightTempo)
        }
        
        var percentageToMatch =  tempo.master / tempo.sync - 1
        
        if tempo.sync.rounded() != tempo.master.rounded() {
            switch true {
            case abs(percentageToMatch) <= pitchRange:
                print("Regular perc: \(percentageToMatch), sync: \(tempo.sync), master: \(tempo.master)")
                composeHintText(percentageToMatch)
                return true
            case tempo.sync < tempo.master:
                let syncTempoFloor = (tempo.sync * 2) * (1 - pitchRange) // test if accurate
                let syncTempoCeiling = (tempo.sync * 2) * (1 + pitchRange) // test if accurate
                
                if syncTempoFloor < tempo.master &&  syncTempoCeiling > tempo.master {
                    let percentage = tempo.master / (tempo.sync * 2) - 1
                    percentageToMatch = percentage / 2
                    composeHintText(percentageToMatch)
                    return true
                } else {
                    hintOutOfRange()
                    return false
                }
            case tempo.sync > tempo.master:
                let syncTempoFloor = (tempo.sync / 2) * (1 - pitchRange) // test if accurate
                let syncTempoCeiling = (tempo.sync / 2) * (1 + pitchRange) // test if accurate
                
                if syncTempoFloor < tempo.master && syncTempoCeiling > tempo.master {
                    percentageToMatch = tempo.master / (tempo.sync / 2) - 1
                    composeHintText(percentageToMatch)
                    return true
                } else {
                    hintOutOfRange()
                    return false
                }
            default:
                return false
            }
        } else {
            print("Already matched")
            return false
        }
    }
}
