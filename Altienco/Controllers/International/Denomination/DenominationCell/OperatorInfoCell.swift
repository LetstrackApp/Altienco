//
//  OperatorInfoCell.swift
//  Altienco
//
//  Created by mac on 18/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class OperatorInfoCell: UITableViewCell {

    @IBOutlet weak var operatorTitle: UILabel!
    
    @IBOutlet weak var operatorValue: UILabel!
    @IBOutlet weak var countryValue: UILabel!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var mobileTitle: UILabel!
    @IBOutlet weak var mobilenumValue: UILabel!
    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 6
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
