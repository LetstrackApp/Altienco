//
//  Boxing.swift
//  LTRetail
//
//  Created by mac on 07/08/20.
//  Copyright © 2020 Diwakar Kumar. All rights reserved.
//

import Foundation
class Box<T>{
    typealias Listener = (T) -> Void
    var listener : Listener?
    var value : T{
        didSet{
          listener?(value)
        }
    }
    
    init(_ value : T) {
        self.value = value
    }
    
    func bind(listener : Listener?){
        self.listener = listener
        listener?(value)
    }
}
