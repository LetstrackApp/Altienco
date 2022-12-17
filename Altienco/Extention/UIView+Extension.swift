//
//  UIViewController+Extension.swift
//  Altienco
//
//  Created by mac on 16/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

public extension  UIView {
   
    func addTarget(target:UIViewController, action : Selector){
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    
}
