//
//  DenoCell.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class DenoCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.layer.cornerRadius = 10
            viewContainer.showLoading()

        }
    }

@IBOutlet weak var destinationPrice: UILabel!
@IBOutlet weak var destinationUnit: UILabel!
@IBOutlet weak var sourceAmount: UILabel!
@IBOutlet weak var data: UILabel!
@IBOutlet weak var planDescription: UILabel!
@IBOutlet weak var validity: UILabel!
@IBOutlet weak var selectPlan: UIButton!

override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    // Initialization code
}

    func setupUI(model: LastRecharge){
        self.sourceAmount.layer.borderColor = appColor.buttonBackColor.cgColor
        self.selectPlan.layer.borderColor = appColor.purpleColor.cgColor
        self.selectPlan.layer.cornerRadius = self.selectPlan.frame.self.height/2
        self.selectPlan.layer.borderWidth = 1.0
        self.selectPlan.clipsToBounds=true
        self.sourceAmount.layer.cornerRadius = 6.0
        self.sourceAmount.layer.borderWidth = 1.0
        self.sourceAmount.clipsToBounds=true
        
        
        self.destinationPrice.text = "\(model.destinationAmount ?? 0.0)"
        self.destinationUnit.text = model.destinationUnit
        self.sourceAmount.text =  "  " + String(format: "%.2f", model.retailAmount ?? 0.0) +  "  \(model.retailUnit ?? "NA")  "
        self.data.text = model.data
        self.planDescription.text = model.lastRechargeDescription
        self.updateConstraintsIfNeeded()
        
        if model.validityQuantity == -1 {
            validity.text = "Unlimited"
            return
        }
        else if let validityQuantity = model.validityQuantity,
                validityQuantity > 0 {
            validity.text = "\(validityQuantity)" + (model.validityUnit ?? "NA")
            return
        }else {
            validity.text = "NA"
            return
        }
        
        
        
        
    }

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}

}
