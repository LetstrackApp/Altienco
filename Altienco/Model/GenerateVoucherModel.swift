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
    var orderId:String?
    var isOriginAltienco:Int?

    enum CodingKeys: String, CodingKey {
        case voucherID = "voucherId"
        case walletAmount, planName, currency, dinominationValue, mPIN, msgToShare,isOriginAltienco
    }
    
    init(){
        
    }
    
    init(json: [String:Any]){
        self.orderId = json["orderId"] as? String
        self.voucherID = json["voucherId"] as? Int
        self.walletAmount = json["walletAmount"] as? Double
        self.planName = json["planName"] as? String
        self.currency = json["currency"] as? String
        self.dinominationValue = json["dinominationValue"] as? Int
        self.mPIN = json["mPIN"] as? String
        self.msgToShare = json["msgToShare"] as? String
        self.isOriginAltienco = json["isOriginAltienco"] as? Int
    }
}




struct ConfirmingIntrPINBankVoucherModel: Decodable {
    var apiId : String?
    var confirmationExpiryDate :String?
    var currency :String?
    var externalId: String?
    var firstStep_ActivityDate:String?
    var processStatusId: Int?
    var secondStep_ActivityDate:String?
    var walletAmount :String?

    
    init(json: [String:Any]){
        self.apiId = json["apiId"] as? String
        self.confirmationExpiryDate = json["confirmationExpiryDate"] as? String
        self.currency = json["currency"] as? String
        self.externalId = json["externalId"] as? String
        self.firstStep_ActivityDate = json["firstStep_ActivityDate"] as? String
        self.processStatusId = json["processStatusId"] as? Int
        self.secondStep_ActivityDate = json["secondStep_ActivityDate"] as? String
        self.walletAmount = json["walletAmount"] as? String
    }
}
