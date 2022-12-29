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
    @IBOutlet weak var repeatRecharge: UIButton! {
        didSet {
            repeatRecharge.layer.cornerRadius = 8
            repeatRecharge.titleLabel?.font = UIFont.SF_Regular(14)
            repeatRecharge.setTitle(lngConst.reOrder, for: .normal)
        }
    }
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
            self.orderNumber.font = UIFont.SF_SemiBold(12.0)
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
    
    var model : HistoryResponseObj! {
        didSet {
            if model.processStatusId != 3{
                self.orderStatus.textColor = appColor.buttonGreenColor
            }
            else {
                self.orderStatus.textColor = appColor.buttonRedColor
            }
            
            self.orderStatus.text = model.transactionMessage
            self.orderNumber.text = "\(lngConst.orderNo): " + (model.orderNumber ?? "")
            self.rechargeType.text = model.transactionType
            if let amount = model.amount{
                self.amount.text = (model.currency ?? "") + "\(amount)"
            }
            if model.transactionTypeID == 2 || model.transactionTypeID == 5 {
                //        if model.transactionTypeID == 2  {
                
                self.repeatContainer.isHidden = false
            }
            else{
                self.repeatContainer.isHidden = true
            }
            if let time = model.transactionDate{
                self.date.text = time.convertToDisplayFormat()}
        }
    }
    
}

    
