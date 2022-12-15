//
//  RegistrationModel.swift
//  Altienco
//
//  Created by Ashish on 02/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

// MARK: - CartItemResponseObj
struct RegistrationModel: Encodable {
    let mobileCode, mobileNumber, profileImage, countryCode: String?
    let firstName, lastName, emailID,referredCode, langCode: String?
    let isAvatarImage: Bool?
    
    enum CodingKeys: String, CodingKey {
        case langCode = "langCode"
        case mobileCode = "mobileCode"
        case mobileNumber = "mobileNumber"
        case profileImage = "profileImage"
        case countryCode = "countryCode"
        case firstName = "firstName"
        case lastName = "lastName"
        case emailID = "emailID"
        case isAvatarImage = "isAvatarImage"
        case referredCode = "referredCode"
        
    }
}
