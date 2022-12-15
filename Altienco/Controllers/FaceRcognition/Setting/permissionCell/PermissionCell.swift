//
//  PermissionCell.swift
//  Altienco
//
//  Created by Ashish on 14/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class PermissionCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchPermission: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchPermission.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
