//
//  BPMSingleton.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 10/03/2018.
//  Copyright © 2018 Anton Skvartsou. All rights reserved.
//

import Foundation

class BPMService {
    static let sharedInstance = BPMService()
    
    var leftDeckBPM: Int? = nil
    var rightDeckBPM: Int? = nil
    
    var currentPitchRange = PitchRange.eight
    var sideOnAir: Side = .left
}
