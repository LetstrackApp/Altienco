//
//  VoucherHistoryModel.swift
//  Altienco
//
//  Created by Ashish on 09/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
// MARK: - CartItemResponseObj
struct VoucherHistoryRequestObj: Codable {
    let customerId: String
    let isRequiredAll: Bool
    let langCode: String
    let operatorId: Int
    let pinBankUsedStatus: Int
    let pageNum, pageSize, transactionTypeId: Int?
    

    enum CodingKeys: String, CodingKey {
        case customerId, operatorId
        case isRequiredAll, langCode, pinBankUsedStatus
        case pageNum, pageSize, transactionTypeId
    }

}
// MARK: - CartItemResponseObj
class VoucherHistoryResponseObj: Codable {
    let fkUserID: Int?
    let currency: String?
    let imageURL: String?
    var isUsed : Bool = false
    let operatorID: Int?
    let operatorName, orderNumber, planName, transactionDate, msgToShare, mPIN : String?
    let voucherAmount, transactionTypeId, voucherId: Int?
    let transactionMessage: String?
    let transactionStatus : Int?
    enum CodingKeys: String, CodingKey {
        case fkUserID
        case currency
        case imageURL
        case isUsed
        case operatorID
        case operatorName, orderNumber, planName, transactionDate, voucherAmount, msgToShare
        case transactionTypeId, voucherId, mPIN,transactionMessage,transactionStatus
    }

    
    init(json:[String: Any]) {
        self.transactionStatus = json["transactionStatus"] as? Int

        self.transactionMessage = json["transactionMessage"] as? String
        self.fkUserID = json["userId"] as? Int
        self.operatorID = json["operatorId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.planName = json["planName"] as? String
        self.isUsed = json["isUsed"] as? Bool ?? false
        self.currency = json["currency"] as? String
        self.voucherAmount = json["voucherAmount"] as? Int
        self.orderNumber = json["orderNumber"] as? String
        self.transactionDate = json["transactionDate"] as? String
        self.imageURL = json["imageUrl"] as? String
        self.transactionTypeId = json["transactionTypeId"] as? Int
        self.msgToShare = json["msgToShare"] as? String
        self.mPIN = json["mPIN"] as? String
        self.voucherId = json["voucherId"] as? Int
    }
}
