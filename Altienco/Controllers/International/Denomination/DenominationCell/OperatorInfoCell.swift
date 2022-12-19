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
    @IBOutlet weak var container: UIView! 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupCellData(mobile:String?,
                       country:String?,
                       planOperator:String?) {
        countryValue.text = country
        operatorValue.text = planOperator
        mobilenumValue.text = mobile
        container.layer.cornerRadius = 6
        mobilenumValue.font = UIFont.SF_Medium(13)
        mobileTitle.font = UIFont.SFPro_Light(13)
        countryTitle.font = UIFont.SFPro_Light(13)
        operatorTitle.font = UIFont.SFPro_Light(13)
        operatorValue.font = UIFont.SF_Medium(13)
        countryValue.font = UIFont.SF_Medium(13)
    }
    
}
