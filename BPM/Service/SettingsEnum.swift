//
//  SettingsEnum.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 12/03/2018.
//  Copyright © 2018 Anton Skvartsou. All rights reserved.
//

import UIKit

enum PitchRange: Double {
    case eight = 0.08
    case ten = 0.1
    case sixteen = 0.16
    case twenty = 0.2
    case fifty = 0.5
    
    var description: String {
        switch self {
        case .eight:
            return "+/- 8"
        case .ten:
            return "-/+ 10"
        case .sixteen:
            return "-/+ 16"
        case .twenty:
            return "-/+ 20"
        case .fifty:
            return "-/+ 50"
        }
    }
}
