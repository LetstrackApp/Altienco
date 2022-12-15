//
//  ToastView.swift
//  LMDispatcher
//
//  Created by APPLE on 21/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0

    
    static func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        let label = UILabel()
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0
        label.text = text
        label.numberOfLines = 0

//        var vertical: CGFloat = 0
        var size = label.intrinsicContentSize
        var width = min(size.width, window.frame.width - 60)
        if width != size.width {
//            vertical = 10
            label.textAlignment = .justified
        }
        
        size = label.intrinsicContentSize
        width = min(size.width+30, window.frame.width - 60)

        label.frame = CGRect(x: 20, y: window.frame.maxY - window.frame.maxY/4, width: width, height: size.height + 20)
        label.center.x = window.center.x
        label.layer.cornerRadius = min(label.frame.height/2, 25)
        label.layer.masksToBounds = true
        window.addSubview(label)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
}
