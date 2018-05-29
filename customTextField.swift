//
//  customTextField.swift
//  Cantina
//
//  Created by Incipientinfo-IOS1 on 2/3/18.
//  Copyright © 2018 AppToDate. All rights reserved.
//

import UIKit

@IBDesignable
class customTextField: UITextField {
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            let viewLeft: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 60))// set per your requirement
            viewLeft.addSubview(imageView)
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = viewLeft
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}

