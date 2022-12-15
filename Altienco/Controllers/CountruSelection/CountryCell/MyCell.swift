//
//  CountryCell.swift
//  LMDispatcher
//
//  Created by APPLE on 08/10/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import DropDown

open class CountryCell: UITableViewCell {
    @IBOutlet weak var countryTitle: UILabel!
}

class MyCell: DropDownCell {
    @IBOutlet weak var logoImageView: UIImageView!{
        didSet{
            logoImageView.layer.cornerRadius = self.logoImageView.layer.frame.height/2
            logoImageView.clipsToBounds=true
        }
    }
}
