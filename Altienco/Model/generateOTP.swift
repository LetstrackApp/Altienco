//
//  generateOTP.swift
//  Altienco
//
//  Created by Ashish on 22/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import UIKit

struct GenerateOTP: Encodable {
    let langCode, mobileCode, mobileNumber, deviceId: String?
    let deviceType, deviceOSVersion, buildVersion : String?

    enum CodingKeys: String, CodingKey {
        case langCode = "langCode"
        case mobileCode = "mobileCode"
        case mobileNumber = "mobileNumber"
        case deviceId = "deviceId"
        case deviceType = "deviceType"
        case deviceOSVersion = "deviceOSVersion"
        case buildVersion = "buildVersion"
    }
    
}
