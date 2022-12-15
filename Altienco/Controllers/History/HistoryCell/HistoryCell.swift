//
//  HistoryCell.swift
//  LMRider
//
//  Created by APPLE on 01/12/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var repeatContainer: UIView!
    @IBOutlet weak var repeatRecharge: UIButton!
    @IBOutlet weak var rechargeType: UILabel!{
        didSet{
            self.rechargeType.font = UIFont.SF_Medium(14.0)
            self.rechargeType.textColor = appColor.blackText
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
    @IBOutlet weak var orderNumber: UILabel!{
        didSet{
            self.orderNumber.font = UIFont.SFPro_Light(12.0)
            self.orderNumber.textColor = appColor.lightGrayText
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

    
