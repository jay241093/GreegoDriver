//
//  ImageHelper.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 04/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
func ImageBase64(im:UIImage) -> String{
    if let base64String =  UIImageJPEGRepresentation(im, 1)?.base64EncodedString() {
        print("Base64 Convirsion success",base64String)
        return base64String
    }else{
        return ""

    }
}
//func ImageResizeAndBase64(im: UIImage, maxSize: CGFloat) -> String {
//    
//    return (UIImageJPEGRepresentation(im, getCompressionRatio(image: im, maxSize: maxSize))?.base64EncodedString())!
//    
//}

func getCompressionRatio(im:UIImage,maxSize:CGFloat) -> CGFloat{
    let imageSize = im.size.height * im.size.width
    if imageSize < maxSize {
        return 1.0
        
    }else{
        return maxSize / imageSize
    }
}
