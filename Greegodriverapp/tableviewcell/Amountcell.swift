//
//  Amountcell.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/18/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class Amountcell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var lbldatetime: UILabel!
    
    @IBOutlet weak var lbltotaltime: UILabel!
    @IBOutlet weak var lblcost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
