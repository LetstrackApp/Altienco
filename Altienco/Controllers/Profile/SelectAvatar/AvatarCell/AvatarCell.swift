//
//  AvatarCell.swift
//  Altienco
//
//  Created by Ashish on 14/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!{
        didSet{
            avatarImage.layer.cornerRadius = 6.0
            avatarImage.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 6.0
        self.contentView.clipsToBounds = true
        // Initialization code
    }

}
