//
//  UIBorderedImageView.swift
//
//  Created by Andres Rizzo on 29/8/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

@IBDesignable
class UIBorderedImageView: UIImageView {
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            layer.cornerRadius = frame.width * 0.5
            layer.masksToBounds = frame.width * 0.5 > 0
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            if !rounded{
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if !rounded{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func draw(_ rect: CGRect) {
        if !rounded{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
