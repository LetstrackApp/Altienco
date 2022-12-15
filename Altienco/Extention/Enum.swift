//
//  Enum.swift
//  Altienco
//
//  Created by Ashish on 15/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import UIKit


enum AvatarPics : CaseIterable {
    case avatar1
    case avatar2
    case avatar3
    case avatar4
    case avatar5
    case avatar6
    case avatar7
    case avatar8
    case avatar9
    case avatar10
    case avatar11
    case avatar12
    case avatar13
    case avatar14
    case avatar15
    case avatar16
    case avatar17
    case avatar18
    case avatar19
    case avatar20
    case avatar21
    case avatar22
    case avatar23
    case avatar24
    case avatar25
    case avatar26
    case avatar27
    case avatar28
    case avatar29
    case avatar30
    case avatar31
    case avatar32
    case avatar33
    case avatar34
    case avatar35
    case avatar36
    case avatar37
    case avatar38
    case avatar39
    case avatar40
    
    static func element(at index: Int) -> AvatarPics? {
        let elements = [AvatarPics.avatar1, AvatarPics.avatar2, AvatarPics.avatar3, AvatarPics.avatar4, AvatarPics.avatar5, AvatarPics.avatar6, AvatarPics.avatar7, AvatarPics.avatar8, AvatarPics.avatar9, AvatarPics.avatar10, AvatarPics.avatar11, AvatarPics.avatar12, AvatarPics.avatar13, AvatarPics.avatar14, AvatarPics.avatar15, AvatarPics.avatar16, AvatarPics.avatar17, AvatarPics.avatar18, AvatarPics.avatar19, AvatarPics.avatar20, AvatarPics.avatar21, AvatarPics.avatar22, AvatarPics.avatar23, AvatarPics.avatar24, AvatarPics.avatar25, AvatarPics.avatar26, AvatarPics.avatar27, AvatarPics.avatar28, AvatarPics.avatar29, AvatarPics.avatar30, AvatarPics.avatar31, AvatarPics.avatar32, AvatarPics.avatar33, AvatarPics.avatar34, AvatarPics.avatar35, AvatarPics.avatar36, AvatarPics.avatar37, AvatarPics.avatar38, AvatarPics.avatar39, AvatarPics.avatar40]

            if index >= 0 && index < elements.count {
                return elements[index]
            } else {
                return nil
            }
        }
    
    var name : String? {
        switch self {
        case .avatar1:
            return "avatar1"
        case .avatar2:
            return  "avatar2"
        case .avatar3:
            return  "avatar3"
        case .avatar4:
            return  "avatar4"
        case .avatar5:
            return  "avatar5"
        case .avatar6:
            return  "avatar6"
        case .avatar7:
            return  "avatar7"
        case .avatar8:
            return  "avatar8"
        case .avatar9:
            return  "avatar9"
        case .avatar10:
            return  "avatar10"
        case .avatar11:
            return  "avatar11"
        case .avatar12:
            return  "avatar12"
        case .avatar13:
            return  "avatar13"
        case .avatar14:
            return  "avatar14"
        case .avatar15:
            return  "avatar15"
        case .avatar16:
            return  "avatar16"
        case .avatar17:
            return  "avatar17"
        case .avatar18:
            return  "avatar18"
        case .avatar19:
            return  "avatar19"
        case .avatar20:
            return  "avatar20"
        case .avatar21:
            return  "avatar21"
        case .avatar22:
            return  "avatar22"
        case .avatar23:
            return  "avatar23"
        case .avatar24:
            return  "avatar24"
        case .avatar25:
            return  "avatar25"
        case .avatar26:
            return  "avatar26"
        case .avatar27:
            return  "avatar27"
        case .avatar28:
            return  "avatar28"
        case .avatar29:
            return  "avatar29"
        case .avatar30:
            return  "avatar30"
        case .avatar31:
            return  "avatar31"
        case .avatar32:
            return  "avatar32"
        case .avatar33:
            return  "avatar33"
        case .avatar34:
            return  "avatar34"
        case .avatar35:
            return  "avatar35"
        case .avatar36:
            return  "avatar36"
        case .avatar37:
            return  "avatar37"
        case .avatar38:
            return  "avatar38"
        case .avatar39:
            return  "avatar39"
        case .avatar40:
            return  "avatar40"
        }
    }
    
    
    var setImage : UIImage? {
        switch self {
        case .avatar1:
            return UIImage(named: "avatar1")
        case .avatar2:
            return UIImage(named: "avatar2")
        case .avatar3:
            return UIImage(named: "avatar3")
        case .avatar4:
            return UIImage(named: "avatar4")
        case .avatar5:
            return UIImage(named: "avatar5")
        case .avatar6:
            return UIImage(named: "avatar6")
        case .avatar7:
            return UIImage(named: "avatar7")
        case .avatar8:
            return UIImage(named: "avatar8")
        case .avatar9:
            return UIImage(named: "avatar9")
        case .avatar10:
            return UIImage(named: "avatar10")
        case .avatar11:
            return UIImage(named: "avatar11")
        case .avatar12:
            return UIImage(named: "avatar12")
        case .avatar13:
            return UIImage(named: "avatar13")
        case .avatar14:
            return UIImage(named: "avatar14")
        case .avatar15:
            return UIImage(named: "avatar15")
        case .avatar16:
            return UIImage(named: "avatar16")
        case .avatar17:
            return UIImage(named: "avatar17")
        case .avatar18:
            return UIImage(named: "avatar18")
        case .avatar19:
            return UIImage(named: "avatar19")
        case .avatar20:
            return UIImage(named: "avatar20")
        case .avatar21:
            return UIImage(named: "avatar21")
        case .avatar22:
            return UIImage(named: "avatar22")
        case .avatar23:
            return UIImage(named: "avatar23")
        case .avatar24:
            return UIImage(named: "avatar24")
        case .avatar25:
            return UIImage(named: "avatar25")
        case .avatar26:
            return UIImage(named: "avatar26")
        case .avatar27:
            return UIImage(named: "avatar27")
        case .avatar28:
            return UIImage(named: "avatar28")
        case .avatar29:
            return UIImage(named: "avatar29")
        case .avatar30:
            return UIImage(named: "avatar30")
        case .avatar31:
            return UIImage(named: "avatar31")
        case .avatar32:
            return UIImage(named: "avatar32")
        case .avatar33:
            return UIImage(named: "avatar33")
        case .avatar34:
            return UIImage(named: "avatar34")
        case .avatar35:
            return UIImage(named: "avatar35")
        case .avatar36:
            return UIImage(named: "avatar36")
        case .avatar37:
            return UIImage(named: "avatar37")
        case .avatar38:
            return UIImage(named: "avatar38")
        case .avatar39:
            return UIImage(named: "avatar39")
        case .avatar40:
            return UIImage(named: "avatar40")
        }
    }
    
    
    
    
}
