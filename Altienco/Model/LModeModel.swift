//
//  LModeModel.swift
//  LMRider
//
//  Created by APPLE on 14/01/21.
//  Copyright © 2021 Letstrack. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Welcome
class LModeModel: Codable {
    let isOnline: Int
    let mobileMake, mobileModel, mobileOSType, mobileOSVersion: String
    let mobileRegID, pkUserID: String

    enum CodingKeys: String, CodingKey {
        case isOnline = "Is_Online"
        case mobileMake = "Mobile_Make"
        case mobileModel = "Mobile_Model"
        case mobileOSType = "Mobile_OS_Type"
        case mobileOSVersion = "Mobile_OS_Version"
        case mobileRegID = "Mobile_Reg_ID"
        case pkUserID = "PK_User_ID"
    }

    init(isOnline: Int, mobileMake: String="Apple", mobileModel: String="\(UIDevice.current.model)", mobileOSType: String="IOS", mobileOSVersion:String="\(UIDevice.current.systemVersion)", mobileRegID: String="\(UIDevice.current.model)", pkUserID: String) {
        self.isOnline = isOnline
        self.mobileMake = mobileMake
        self.mobileModel = mobileModel
        self.mobileOSType = mobileOSType
        self.mobileOSVersion = mobileOSVersion
        self.mobileRegID = mobileRegID
        self.pkUserID = pkUserID
    }
}
