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
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 5
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
            self.viewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var destinationPrice: UILabel!
    @IBOutlet weak var destinationUnit: UILabel!
    @IBOutlet weak var sourceAmount: UILabel!{
        didSet{
            self.sourceAmount.layer.cornerRadius = 6.0
            self.sourceAmount.layer.borderWidth = 1.0
            self.sourceAmount.layer.borderColor = appColor.buttonBackColor.cgColor
            self.sourceAmount.clipsToBounds=true
        }
    }
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var planDescription: UILabel!
    @IBOutlet weak var validity: UILabel!
    @IBOutlet weak var selectPlan: UIButton!{
        didSet{
            self.selectPlan.layer.cornerRadius = self.selectPlan.frame.self.height/2
            self.selectPlan.layer.borderColor = appColor.purpleColor.cgColor
            self.selectPlan.layer.borderWidth = 1.0
            self.selectPlan.clipsToBounds=true
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
