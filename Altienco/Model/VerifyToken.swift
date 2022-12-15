//
//  VerifyToken.swift
//  LMDispatcher
//
//  Created by APPLE on 30/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation

struct VerifyToken: Codable {
    let token, mobileNo, mobileRegID, mobileMake: String?
    let mobileModel, mobileOSVersion, mobileOSType: String?

    enum CodingKeys: String, CodingKey {
        case token
        case mobileNo = "Mobile_No"
        case mobileRegID = "Mobile_Reg_ID"
        case mobileMake = "Mobile_Make"
        case mobileModel = "Mobile_Model"
        case mobileOSVersion = "Mobile_OS_Version"
        case mobileOSType = "Mobile_OS_Type"
    }
}
