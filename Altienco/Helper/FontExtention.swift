//
//  FontExtention.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import UIKit


extension UIFont{
    
    class func SF_Regular(_ size : CGFloat)-> UIFont?{
        let size = sizeAccordingToDevice(size)
        return UIFont(name: "Poppins-Regular", size: size)
    }
    class func SF_Bold(_ size : CGFloat)-> UIFont?{
        let size = sizeAccordingToDevice(size)
        return UIFont(name: "Poppins-Bold", size: size)
    }
    class func SF_Medium(_ size : CGFloat)-> UIFont?{
        let size = sizeAccordingToDevice(size)
        return UIFont(name: "Poppins-Medium", size: size)
    }
    class func SF_SemiBold(_ size : CGFloat)-> UIFont?{
        let size = sizeAccordingToDevice(size)
        return UIFont(name: "Poppins-SemiBold", size: size)
    }
    class func SFPro_Light(_ size : CGFloat)-> UIFont?{
        let size = sizeAccordingToDevice(size)
        return UIFont(name: "Poppins-Light", size: size)
    }
    
    
    
    class func sizeAccordingToDevice(_ size : CGFloat) ->CGFloat{
        if (UI_USER_INTERFACE_IDIOM() == .pad)
        {
            return size + 4
        }else {
            switch UIDevice().type {
            case .iPhone4,.iPhone4S:
                return size - 3
            case .iPhone5,.iPhone5S,.iPhone5C:
                return size - 2
            case .iPhone6,.iPhone7,.iPhone8,.iPhoneSE,.iPhone6S:
                return size
            case .iPhone6plus,.iPhone7plus,.iPhone8plus,.iPhoneX,.iPhoneXR,.iPhone11,.iPhoneXS,.simulator:
                return size + 1
            case .iPhoneXSmax,.iPhone11Pro,.iPhone11ProMax:
                return size + 2
            default:return size
                
            }
        }
    }
    
}
