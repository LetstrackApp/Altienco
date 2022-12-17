//
//  ViewLoadable.swift
//  Altienco
//
//  Created by mac on 17/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
public protocol ViewLoadable : AnyObject{
    static var nibName: String { get }
}


public extension ViewLoadable{
    static func loadFromNib()-> Self{
        return loadFromNib(from: Bundle.init(for: self) )
    }
    
    static func loadFromNib(from bundle: Bundle?) -> Self  {
        return bundle?.loadNibNamed(self.nibName, owner: nil, options: nil)?.first as! Self
    }
}



