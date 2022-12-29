//
//  ToastView.swift
//  LMDispatcher
//
//  Created by APPLE on 21/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import Toast_Swift
import AVFoundation
class Helper {
    var player: AVAudioPlayer?
    var isAlertShown = false
    var alert: AltienoAlert?
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0
    static let shared = Helper()
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
                    Helper.shared.showAlertView(message: text)
                    return
                }else {
                    
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.makeToast(text, duration: 6, position: position) { (result) in
                    }
                }
            }
        }
    }
    
    func showAlertView(message: String){
        if message.trimWhiteSpace.isEmpty == true  {
            return
        }
        if isAlertShown == true {
            alert?.lblAlertText?.text = message
            return
        }
        alert = AltienoAlert.initialization()
        alert?.showAlert(with: .other(message)) { (index, title) in
        }
        
    }
    
    
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "alertSound", ofType:"mpeg") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}



