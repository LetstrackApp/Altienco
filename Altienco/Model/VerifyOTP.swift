//
//  VerifyOTP.swift
//  LMDispatcher
//
//  Created by APPLE on 15/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation

struct VerifyOTP: Codable {
    
    let mobileCode, mobileNumber, langCode : String
    var otp: String = ""

    enum CodingKeys: String, CodingKey {
        case mobileCode = "mobileCode"
        case mobileNumber = "mobileNumber"
        case otp = "otp"
        case langCode = "langCode"
    }
    
    /// need to update
    init(otp:String, mobileCode: String = UserDefaults.getMobileCode, mobileNumber:String = UserDefaults.getMobileNumber, langCode:String = "en") {
        self.otp = otp
        self.mobileNumber = mobileNumber
        self.mobileCode = mobileCode
        self.langCode = langCode
        
    }
}

struct ResendOTP: Codable {
    
    let mobileCode, mobileNumber, langCode : String
    var otp: String = ""

    enum CodingKeys: String, CodingKey {
        case mobileCode = "mobileCode"
        case mobileNumber = "mobileNumber"
        case langCode = "langCode"
    }
    
    /// need to update
    init(mobileCode: String = UserDefaults.getMobileCode, mobileNumber:String = UserDefaults.getMobileNumber, langCode:String = "en") {
        self.mobileNumber = mobileNumber
        self.mobileCode = mobileCode
        self.langCode = langCode
        
    }
}
