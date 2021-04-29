//
//  UILabel+Extension.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 07/04/2019.
//  Copyright © 2019 Anton Skvartsou. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = nil, color: UIColor? = nil) {
        self.init()
        self.text = text
        if let font = font {
            self.font = font
        }
        if let color = color {
            self.textColor = color
        }
    }
}
