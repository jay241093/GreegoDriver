//
//  Constant.swift
//  GreeGo
//
//  Created by Pish Selarka on 17/04/18.
//  Copyright © 2018 Techrevere. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
