//
//  componentsTableViewCell.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class componentsTableViewCell: UITableViewCell {

    @IBOutlet weak var componentImageView: UIImageView!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var componentNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        componentImageView.layer.cornerRadius = componentImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
