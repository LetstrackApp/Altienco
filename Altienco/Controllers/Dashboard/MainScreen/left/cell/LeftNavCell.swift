//
//  LeftNavCell.swift
//  LMDispatcher
//
//  Created by APPLE on 24/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit

class LeftNavCell: UITableViewCell {
    
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nextIcon: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
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
