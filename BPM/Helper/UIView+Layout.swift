//
//  Extensions+UIView.swift
//  SlideOutMenuInProgress
//
//  Created by Brian Voong on 9/30/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

extension UIView {
    convenience init(size: Size, color: UIColor? = nil) {
        self.init(frame: .zero)
        
        anchorSize(size: size)
        backgroundColor = color
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height, centerX, centerY: NSLayoutConstraint?
}

extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: Size = .init(width: nil, height: nil)) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if let width = size.width {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: width)
        }
        
        if let height = size.height {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: Size = .init(width: nil, height: nil), axis: Axis? = nil, offset: CGPoint = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { fatalError() }
        
        guard let axis = axis else {
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)
                ])
            
            return
        }
        
        if axis.isX {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x).isActive = true
        } else {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y).isActive = true
        }
        
        anchorSize(size: size)
    }
    
    func anchorSize(size: Size) {
        if let width = size.width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = size.height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func anchorSizeTo(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorInSuperview(padding: Padding) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        
        if let topPadding = padding.top {
            topAnchor.constraint(
                equalTo: superview.topAnchor,
                constant: topPadding
            ).isActive = true
        }
        
        if let leftPadding = padding.left {
            leadingAnchor.constraint(
                equalTo: superview.leadingAnchor,
                constant: leftPadding
            ).isActive = true
        }
        
        if let bottomPadding = padding.bottom {
            bottomAnchor.constraint(
                equalTo: superview.bottomAnchor,
                constant: -bottomPadding
            ).isActive = true
        }
        
        if let rightPadding = padding.right {
            trailingAnchor.constraint(
                equalTo: superview.trailingAnchor,
                constant: -rightPadding
            ).isActive = true
        }
    }
}

struct Size {
    let width: CGFloat?
    let height: CGFloat?
}

struct Axis {
    let isX: Bool
}

struct Padding {
    let top: CGFloat?
    let left: CGFloat?
    let bottom: CGFloat?
    let right: CGFloat?
}
