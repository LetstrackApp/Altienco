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
                          isAlertView:Bool = false,isError:Bool = true) {
        
        DispatchQueue.main.async {
            if let text = text,
               text.trimWhiteSpace != "" {
                Helper.hideToast()
                if isAlertView == true {
                    Helper.shared.showAlertView(message: text,isError:isError)
                    return
                }else {
                    
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.makeToast(text, duration: 6, position: position) { (result) in
                    }
                }
            }
        }
    }
    
    func showAlertView(message: String,isError:Bool = true){
        if message.trimWhiteSpace.isEmpty == true  {
            return
        }
        if isAlertShown == true {
            alert?.lblAlertText?.text = message
            return
        }
        alert = AltienoAlert.initialization()
        alert?.showAlert(with: .fail(message)) { (index, title) in
        }
        
    }
    
    
    
    func playSound(kind : KindOF?) {
        
        guard let soundName = kind?.soundName else { return  }
        if soundName == "errorbuzz" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                self?.playAppSound(soundName: soundName)
            }
        }else {
            playAppSound(soundName: soundName)
        }
        

    }
    
    func playAppSound(soundName : String){
        guard let path = Bundle.main.path(forResource: soundName, ofType:"mpeg") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func showAnimatingDotsInImageView(view:UIView) {
        
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: view.bounds.width + 10, y: view.bounds.height/2, width: 15, height: 7) //yPos == 12
        let circle = CALayer()
        circle.frame = CGRect(x: 0, y: 0, width: 7, height: 7)
        circle.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1).cgColor//lightGray.cgColor //UIColor.black.cgColor
        lay.addSublayer(circle)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        circle.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        
        view.layer.addSublayer(lay)
    }
}



