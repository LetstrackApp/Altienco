//
//  UserModel.swift
//  LMDispatcher
//
//  Created by APPLE on 15/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation

// MARK: - CartItemResponseObj
struct UserModel: Codable {
    var isOtpMatched: Int?
    var profileImage, countryCode: String?
    var customerID: Int?
    var isAvatarImage: Bool?
    var firstName, lastName, emailID, currencySymbol: String?
    var walletAmount: Double?
    var apiToken: String?
    var customerCode, msgToShare, inviteBanner, inviteFooterBanner: String?

    enum CodingKeys: String, CodingKey {
        case isOtpMatched
        case profileImage = "profile_Image"
        case countryCode = "country_Code"
        case customerID = "customer_Id"
        case firstName = "first_Name"
        case lastName = "last_Name"
        case emailID = "email_ID"
        case currencySymbol = "currency_Symbol"
        case isAvatarImage = "isAvatarImage"
        case walletAmount = "wallet_Amount"
        case apiToken = "api_Token"
        case customerCode, msgToShare, inviteBanner, inviteFooterBanner
    }
    init(){
        
    }
    
    init(json: [String: Any]) {
        self.isOtpMatched = json["isOtpMatched"] as? Int
        self.profileImage = json["profile_Image"] as? String
        self.countryCode = json["country_Code"] as? String
        self.customerID = json["customer_Id"] as? Int
        self.firstName = json["first_Name"] as? String
        self.lastName = json["last_Name"] as? String
        self.emailID = json["email_ID"] as? String
        self.currencySymbol = json["currency_Symbol"] as? String
        self.walletAmount = json["wallet_Amount"] as? Double
        self.apiToken = json["api_Token"] as? String
        self.customerCode = json["customerCode"] as? String
        self.msgToShare = json["msgToShare"] as? String
        self.inviteBanner = json["inviteBanner"] as? String
        self.isAvatarImage = json["isAvatarImage"] as? Bool
        self.inviteFooterBanner = json["inviteFooterBanner"] as? String
    }
    
}



