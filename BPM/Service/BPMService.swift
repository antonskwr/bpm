//
//  BPMSingleton.swift
//  Bpm-iphone
//
//  Created by Keeper on 10/03/2018.
//  Copyright © 2018 Keeper. All rights reserved.
//

import Foundation

class BPMService {
    static let sharedInstance = BPMService()
    
    var leftDeckBPM: Int? = 136
    var rightDeckBPM: Int? = 70
    
    var currentPitchRange = PitchRange.eight
    var sideOnAir: Side = .left
}
