//
//  Spinners.swift
//  parentalcontrol
//
//  Created by Sanni Prasad on 02/05/18.
//  Copyright © 2018 metrobit. All rights reserved.
//

import Foundation
import PKHUD
func StartSpinner() {
    PKHUD.sharedHUD.contentView = PKHUDProgressView()
    PKHUD.sharedHUD.show()
}

func StopSpinner() {
    PKHUD.sharedHUD.hide(true)
}



enum labeledSpinnerType {
    case success
    case error
    case spin
    
}
func StartLabeledSpinner(type:labeledSpinnerType,title:String,message:String,hide after:Double) {
    switch type {
    case .success:
        HUD.flash(.labeledSuccess(title: title, subtitle: message), onView: nil, delay: after) { (done) in
            if done{
                HUD.hide()
            }
        }
    case .error:
        HUD.flash(.labeledError(title: title, subtitle: message), onView: nil, delay: after) { (done) in
            if done{
                HUD.hide()
            }
        }
    case .spin:
        HUD.flash(.labeledProgress(title: title, subtitle: message), onView: nil, delay: after) { (done) in
            if done{
                HUD.hide()
            }
        }
    }
}
