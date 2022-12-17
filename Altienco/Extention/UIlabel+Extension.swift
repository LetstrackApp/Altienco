//
//  UIlabel+Extension.swift
//  Altienco
//
//  Created by mac on 16/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

extension UILabel {
    
    func changefont(mainString: String,
                    fontchangeString:String,
                    font:UIFont?) {
        let range = (mainString as NSString).range(of: fontchangeString)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        self.attributedText = mutableAttributedString

    }
    
    func changeColor(mainString: String,
                     stringToColor: String,
                     color:UIColor){
        let range = (mainString as NSString).range(of: stringToColor)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = mutableAttributedString

    }
    
    func changeColorAndFont(mainString: String,
                     stringToColor: String,
                     color:UIColor,
                            font:UIFont?){
        let range = (mainString as NSString).range(of: stringToColor)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        self.attributedText = mutableAttributedString

    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
