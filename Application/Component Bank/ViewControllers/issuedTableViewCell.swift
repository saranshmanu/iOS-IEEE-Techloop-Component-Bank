//
//  issuedTableViewCell.swift
//  E+
//
//  Created by Saransh Mittal on 27/12/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class IssuedTableViewCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var quantityIssued: UILabel!
    @IBOutlet weak var issuedDate: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
