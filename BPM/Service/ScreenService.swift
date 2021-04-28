//
//  ScreenSizeService.swift
//  Bpm-iphone
//
//  Created by Keeper on 23/03/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import UIKit

enum ScreenSize {
    case iPhoneXS, iPhoneSE, iPhone678
}

class ScreenService {
    static let shared = ScreenService()
    
    public func getSize() -> ScreenSize {
        switch UIScreen.main.nativeBounds.height {
        case 2436:
            return .iPhoneXS
        case 1136:
            return .iPhoneSE
        default:
            return .iPhone678
        }
    }
    
    public func isX() -> Bool {
        return ScreenService.shared.getSize() == .iPhoneXS
    }
}
