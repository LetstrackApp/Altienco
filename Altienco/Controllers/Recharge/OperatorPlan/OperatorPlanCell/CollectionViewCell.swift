//
//  CollectionViewCell.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            self.viewContainer.layer.cornerRadius = 5.0
            self.viewContainer.layer.borderWidth = 1.0
            self.viewContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            self.viewContainer.clipsToBounds=true
        }
    }
    
    override var isHighlighted: Bool {
      didSet {
        UIView.animate(withDuration: 0.5) {
          let scale: CGFloat = 0.9
          self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
        }
      }
    }
    
    @IBOutlet weak var plansValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
