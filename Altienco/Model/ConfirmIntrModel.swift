//
//  ConfirmIntrModel.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct ConfirmIntrRequestObj: Codable {
    var customerID: Int?
    var mobileCode, mobileNumber: String?
    var planID: Int?
    var destinationUnit: String?
    var retailAmount, destinationAmount, wholesaleAmount: Double?
    var retailUnit, validityQuantity, wholesaleUnit, validityUnit, cartItemResponseObjDescription: String?
    var data, langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case mobileCode, mobileNumber
        case planID = "planId"
        case destinationAmount, destinationUnit, retailAmount, retailUnit, validityQuantity, validityUnit, wholesaleUnit, wholesaleAmount
        case cartItemResponseObjDescription = "description"
        case data, langCode
    }
}


class ConfirmIntrResponseObj: Codable {
    var walletAmount: Double?
    var currency, externalID, apiID, confirmationExpiryDate: String?
    var processStatusID: Int?

    enum CodingKeys: String, CodingKey {
        case walletAmount, currency
        case externalID = "externalId"
        case apiID = "apiId"
        case confirmationExpiryDate
        case processStatusID = "processStatusId"
    }
    init(json: [String: Any]) {
        self.walletAmount = json["walletAmount"] as? Double
        self.currency = json["currency"] as? String
        self.externalID = json["externalId"] as? String
        self.apiID = json["apiId"] as? String
        self.confirmationExpiryDate = json["confirmationExpiryDate"] as? String
        self.processStatusID = json["processStatusId"] as? Int
    }
}



class CheckOrderStatus: Codable {
    var externalID: String?
    var apiID: Int?
    var processStatusID: Int?
    var statusMessage, claimCode, referenceID, expiryDate: String?
    var refundTxnID, msgtoShare: String?

    enum CodingKeys: String, CodingKey {
        case externalID = "externalId"
        case apiID = "apiId"
        case processStatusID = "processStatusId"
        case statusMessage, claimCode
        case referenceID = "referenceId"
        case expiryDate
        case refundTxnID = "refundTxnId"
        case msgtoShare
    }

    init(json: [String: Any]) {
        self.externalID = json["externalID"] as? String
        self.apiID = json["apiID"] as? Int
        self.processStatusID = json["processStatusID"] as? Int
        self.statusMessage = json["statusMessage"] as? String
        self.claimCode = json["claimCode"] as? String
        self.referenceID = json["referenceID"] as? String
        self.expiryDate = json["expiryDate"] as? String
        self.refundTxnID = json["refundTxnID"] as? String
        self.msgtoShare = json["msgtoShare"] as? String
    }
}
