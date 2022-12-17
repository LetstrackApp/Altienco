//
//  Bundle+Extension.swift
//  Altienco
//
//  Created by mac on 17/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
public extension Bundle{
    static var altiencoBundle : Bundle?{
        return Bundle(identifier: "com.altienco.users")
    }
  

}

public extension UIScreen{
    static var height : CGFloat {
        return UIScreen.main.bounds.size.height
    }
    static var width : CGFloat {
        return UIScreen.main.bounds.size.width
    }
}
