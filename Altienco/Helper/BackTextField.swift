//
//  BackTextField.swift
//  Altienco
//
//  Created by Deepak on 07/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

//MARK:- Enhance UITextfield class
protocol BackFieldDelegate : class {
    func textFieldDidDelete(textField : BackTextField)
}

class BackTextField: UITextField {
    weak var backDelegate: BackFieldDelegate?
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    override func deleteBackward() {
        super.deleteBackward()
        backDelegate?.textFieldDidDelete(textField : self)
    }
}

