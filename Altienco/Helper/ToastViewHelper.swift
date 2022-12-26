//
//  ToastView.swift
//  LMDispatcher
//
//  Created by APPLE on 21/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import Toast_Swift
class Helper {
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0
    
    static func hideToast(){
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.hideAllToasts()
    }
    
    static func showToast(_ text: String?,
                          delay: TimeInterval = DELAY_LONG,
                          position:ToastPosition = .bottom,
                          isAlertView:Bool = false) {
        
        DispatchQueue.main.async {
            if let text = text,
               text.trimWhiteSpace != "" {
                Helper.hideToast()
                if isAlertView == true {
                    Helper.showAlertView(message: text)
                    return
                }else {
                
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.makeToast(text, duration: 6, position: position) { (result) in
                }
                }
            }
        }
    }
    
    static func showAlertView(message: String){
        if message.trimWhiteSpace.isEmpty == true {
            return
        }
        AltienoAlert.initialization().showAlert(with: .other(message)) { (index, title) in
            
        }
    }
}
