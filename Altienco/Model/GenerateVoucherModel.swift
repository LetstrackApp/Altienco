//
//  GenerateVoucherModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct GenerateVoucherModel: Codable {
    let customerID, operatorID, planName, currency: String
    let dinominationValue, langCode: String
    let transactionTypeId: Int

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case operatorID = "operatorId"
        case planName, currency, dinominationValue, langCode
        case transactionTypeId
    }
}


struct GenerateVoucherResponseObj: Codable {
    var voucherID: Int?
    var walletAmount: Double?
    var planName, currency, msgToShare: String?
    var dinominationValue: Int?
    var mPIN: String?

    enum CodingKeys: String, CodingKey {
        case voucherID = "voucherId"
        case walletAmount, planName, currency, dinominationValue, mPIN, msgToShare
    }
    
    init(){
        
    }
    
    init(json: [String:Any]){
        self.voucherID = json["voucherId"] as? Int
        self.walletAmount = json["walletAmount"] as? Double
        self.planName = json["planName"] as? String
        self.currency = json["currency"] as? String
        self.dinominationValue = json["dinominationValue"] as? Int
        self.mPIN = json["mPIN"] as? String
        self.msgToShare = json["msgToShare"] as? String
    }
}


