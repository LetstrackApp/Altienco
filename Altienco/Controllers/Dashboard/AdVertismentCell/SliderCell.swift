//
//  SliderCell.swift
//  Altienco
//
//  Created by Ashish on 05/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SDWebImage

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var thumnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellData(data: AdvertismentResponseObj){
        thumnailImageView.contentMode = .scaleAspectFill
        thumnailImageView.sd_setImage(with: URL(string: data.thumbnail ?? ""), placeholderImage: nil, options: [], context: nil)

    }
}

