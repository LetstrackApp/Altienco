//
//  CountryModel.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import UIKit

struct SelectContry: Encodable {
    
    let isNewUser: Bool
    let fkLanguageID: Int
    let mobileNo, mobileRegID, mobileMake, mobileModel: String
    let mobileOSVersion, mobileOSType: String
    let isDispatcher, fkParentUserID: Int
    let countryCode, mobileCode: String

    enum CodingKeys: String, CodingKey {
        case isNewUser = "IsNewUser"
        case fkLanguageID = "FK_Language_ID"
        case mobileNo = "Mobile_No"
        case mobileRegID = "Mobile_Reg_ID"
        case mobileMake = "Mobile_Make"
        case mobileModel = "Mobile_Model"
        case mobileOSVersion = "Mobile_OS_Version"
        case mobileOSType = "Mobile_OS_Type"
        case isDispatcher = "isDispatcher"
        case countryCode = "Country_Code"
        case mobileCode = "MobileCode"
        case fkParentUserID = "FK_Parent_User_ID"
    }
    
    init(isNewUser:Bool = true, fkLanguageID: Int = 1, mobileNo:String, mobileRegID:String=UIDevice().name, mobileMake:String="Apple", mobileModel:String = "\(UIDevice.current.identifierForVendor?.uuidString)", mobileOSVersion:String="\(UIDevice.current.systemVersion)",  mobileOSType: String = "IOS", isDispatcher:Int, countryCode: String, mobileCode: String, fkParentUserID: Int) {
        
        self.isNewUser = isNewUser
        self.fkLanguageID = fkLanguageID
        self.mobileNo = mobileNo
        self.mobileRegID = mobileRegID
        self.mobileMake = mobileMake
        self.mobileModel = mobileModel
        self.mobileOSVersion = mobileOSVersion
        self.mobileOSType = mobileOSType
        self.isDispatcher = isDispatcher
        self.countryCode = countryCode
        self.mobileCode = mobileCode
        self.fkParentUserID = fkParentUserID
    }
}
