//
//  GiftCardCell.swift
//  Altienco
//
//  Created by Deepak on 10/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class GiftCardCell: UICollectionViewCell {

    @IBOutlet weak var operatorLogo: UIImageView!
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            self.viewContainer.layer.cornerRadius = 8.0
            self.viewContainer.layer.borderWidth = 1.0
            self.viewContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            self.viewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var cardColor: UIView!
    
    
    @IBOutlet weak var showDenomination: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}
