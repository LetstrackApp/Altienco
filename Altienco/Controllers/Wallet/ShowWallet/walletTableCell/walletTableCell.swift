//
//  walletTableCell.swift
//  Altienco
//
//  Created by Ashish on 25/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class walletTableCell: UITableViewCell {

    @IBOutlet weak var orderNumber: UILabel!{
        didSet{
            self.orderNumber.font = UIFont.SFPro_Light(14.0)
            self.orderNumber.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var amount: UILabel!{
        didSet{
            self.amount.font = UIFont.SF_Medium(14.0)
            self.amount.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var date: UILabel!{
        didSet{
            self.date.font = UIFont.SF_Medium(14.0)
            self.date.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var orderStatus: UILabel!{
        didSet{
            self.orderStatus.font = UIFont.SFPro_Light(12.0)
            self.orderStatus.textColor = appColor.buttonGreenColor
        }
    }
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
