//
//  BPMCounter.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 25/04/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import Foundation

class BPMCounter {
    fileprivate var taps = [Date]()
    fileprivate var samples = [Double]()
    fileprivate var tapsCountToRemove = 12
    fileprivate var err: Double = 0.2
    
    public func tapTempo() -> Double? {
        let currentTime = Date(timeIntervalSinceNow: 0)
        taps.append(currentTime)
        samples = [] // Clear samples array
        
        if taps.count > 1 {
            for i in 1..<taps.count {
                let timeSample = taps[i].timeIntervalSince(taps[i - 1]) // Time sample creation
                if let prevSample = samples.last {
                    // If there are entries in samples array
                    switch timeSample {
                    case (prevSample * (1 - err))...(prevSample * (1 + err)):
                        // Check if sample is in error range
                        samples.append(timeSample)
                    default:
                        // Else discard all taps
                        taps = []
                        print("Discard all")
                        return nil
                    }
                } else {
                    samples.append(timeSample)
                }
            }
        }
        
        let rawTempo = (samples.reduce(0) {$0 + $1}) / Double(samples.count)
        let bpmValue = (60 / rawTempo).rounded()
        
        // Adjust control values knowing tempo
        adjustControlValues(tempo: bpmValue)
        
        return !bpmValue.isNaN ? bpmValue : nil
    }
    
    fileprivate func adjustControlValues(tempo: Double) {
        switch true {
        case tempo > 120:
            err = 0.4
            tapsCountToRemove = 24
        case tempo < 60:
            err = 0.1
            tapsCountToRemove = 6
        default:
            err = 0.2
            tapsCountToRemove = 12
        }
        
        if taps.count > tapsCountToRemove {
            taps.remove(at: 0)
            print("Item removed, taps count:", taps.count)
        }
    }
    
}
