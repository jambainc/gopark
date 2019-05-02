//
//  ListControllerTableViewCell.swift
//  GoPark
//
//  Created by Michael Wong on 29/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ListControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSign: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTravelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
