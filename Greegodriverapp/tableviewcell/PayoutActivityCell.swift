//
//  PayoutActivityCell.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/19/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class PayoutActivityCell: UITableViewCell {

    @IBOutlet weak var lblcreated: UILabel!
    
    @IBOutlet weak var lblpayment: UILabel!
    
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
