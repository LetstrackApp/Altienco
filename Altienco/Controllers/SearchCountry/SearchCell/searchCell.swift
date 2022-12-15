//
//  searchCell.swift
//  Altienco
//
//  Created by Ashish on 28/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {

    @IBOutlet weak var labelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
