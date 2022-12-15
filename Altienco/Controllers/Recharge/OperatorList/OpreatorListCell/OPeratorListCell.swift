//
//  OPeratorListCell.swift
//  Altienco
//
//  Created by Ashish on 27/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class OPeratorListCell: UITableViewCell {

    
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var operatorLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
