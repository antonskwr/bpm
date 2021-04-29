//
//  ScreenSizeService.swift
//  Bpm-iphone
//
//  Created by Keeper on 23/03/2019.
//  Copyright © 2019 Keeper. All rights reserved.
//

import UIKit

enum ScreenSize {
    case iPhoneX, iPhone4Inch, iPhone678
}

fileprivate enum Device: String {
    case iPodTouch5
    case iPodTouch6
    case iPodTouch7
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5C
    case iPhone5S
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhone7
    case iPhone7Plus
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhoneSE2
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    case Simulator
    case Other
}

fileprivate func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

fileprivate func mapIdentifierToDevice(deviceId: String) -> Device {
    switch deviceId {
    case "iPod5,1":                                 return Device.iPodTouch5
    case "iPod7,1":                                 return Device.iPodTouch6
    case "iPod9,1":                                 return Device.iPodTouch7
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return Device.iPhone4
    case "iPhone4,1":                               return Device.iPhone4S
    case "iPhone5,1", "iPhone5,2":                  return Device.iPhone5
    case "iPhone5,3", "iPhone5,4":                  return Device.iPhone5C
    case "iPhone6,1", "iPhone6,2":                  return Device.iPhone5S
    case "iPhone7,2":                               return Device.iPhone6
    case "iPhone7,1":                               return Device.iPhone6Plus
    case "iPhone8,1":                               return Device.iPhone6S
    case "iPhone8,2":                               return Device.iPhone6SPlus
    case "iPhone9,1", "iPhone9,3":                  return Device.iPhone7
    case "iPhone9,2", "iPhone9,4":                  return Device.iPhone7Plus
    case "iPhone8,4":                               return Device.iPhoneSE
    case "iPhone10,1", "iPhone10,4":                return Device.iPhone8
    case "iPhone10,2", "iPhone10,5":                return Device.iPhone8Plus
    case "iPhone10,3", "iPhone10,6":                return Device.iPhoneX
    case "iPhone11,2" :                             return Device.iPhoneXS
    case "iPhone11,4", "iPhone11,6":                return Device.iPhoneXSMax
    case "iPhone11,8" :                             return Device.iPhoneXR
    case "iPhone12,1" :                             return Device.iPhone11
    case "iPhone12,3" :                             return Device.iPhone11Pro
    case "iPhone12,5" :                             return Device.iPhone11ProMax
    case "iPhone12,8" :                             return Device.iPhoneSE2
    case "iPhone13,1" :                             return Device.iPhone12Mini
    case "iPhone13,2" :                             return Device.iPhone12
    case "iPhone13,3" :                             return Device.iPhone12Pro
    case "iPhone13,4" :                             return Device.iPhone12ProMax
    case "i386", "x86_64":                          return Device.Simulator
    default:                                        return Device.Other
    }
}

class ScreenService {
    static let shared = ScreenService()
    
    public func getSize() -> ScreenSize {
        let device = mapIdentifierToDevice(deviceId: modelIdentifier())
        switch device {
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR:
            return .iPhoneX
        case .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            return .iPhoneX
        case .iPhone12Mini, .iPhone12, .iPhone12Pro, .iPhone12ProMax:
            return .iPhoneX
        case .iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
            return .iPhone4Inch
        default:
            return .iPhone678
        }
    }
    
    public func isX() -> Bool {
        return ScreenService.shared.getSize() == .iPhoneX
    }
}
