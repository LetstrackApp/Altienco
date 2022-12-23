//
//  VerifyStatusModel.swift
//  Altienco
//
//  Created by Deepak on 27/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct VerifyStatusRequest: Codable {
    var externalID, apiID, confirmationExpiryDate: String?
    var processStatusID: Int?

    enum CodingKeys: String, CodingKey {
        case externalID = "externalId"
        case apiID = "apiId"
        case confirmationExpiryDate
        case processStatusID = "processStatusId"
    }
}


struct VerifyStatusResponce: Codable {
    var apiID: Int?
    var countryName, data, cartItemResponseObjDescription: String?
    var destinationAmount, validityQuantity: Int?
    var destinationUnit, expiryDate: String?
    var externalID: String?
    var msgToShare, operatorName: String?
    var planID, processStatusID: Int?
    var rechargedMobileNumber: String?
    var referenceID, claimCode: String?
    var refundTxnID: String?
    var retailAmount: Double?
    var retailUnit, statusMessage, validityUnit: String?
    var wholesaleAmount, wholesaleUnit, firstStep_ActivityDate, secondStep_ActivityDate, finalStep_ActivityDate, usageInfo: String?
    var orderId: String?

    enum CodingKeys: String, CodingKey {
        case apiID = "apiId"
        case claimCode, countryName, data
        case cartItemResponseObjDescription = "description"
        case destinationAmount, destinationUnit, expiryDate
        case externalID = "externalId"
        case msgToShare, operatorName
        case planID = "planId"
        case processStatusID = "processStatusId"
        case rechargedMobileNumber
        case referenceID = "referenceId"
        case refundTxnID = "refundTxnId"
        case retailAmount, retailUnit, statusMessage, validityQuantity, validityUnit, wholesaleAmount, wholesaleUnit, firstStep_ActivityDate, secondStep_ActivityDate, usageInfo
    }

    init(json: [String: Any]) {
        self.orderId = json["orderId"] as? String
        self.externalID = json["externalId"] as? String
        self.apiID = json["apiId"] as? Int
        self.processStatusID = json["processStatusId"] as? Int
        self.statusMessage = json["statusMessage"] as? String
        self.claimCode = json["claimCode"] as? String
        self.referenceID = json["referenceId"] as? String
        self.expiryDate = json["expiryDate"] as? String
        self.refundTxnID = json["refundTxnId"] as? String
        self.msgToShare = json["msgToShare"] as? String
        self.countryName = json["countryName"] as? String
        self.data = json["data"] as? String
        self.cartItemResponseObjDescription = json["description"] as? String
        self.destinationAmount = json["destinationAmount"] as? Int
        self.destinationUnit = json["destinationUnit"] as? String
        self.operatorName = json["operatorName"] as? String
        self.planID = json["planId"] as? Int
        self.processStatusID = json["processStatusId"] as? Int
        self.rechargedMobileNumber = json["rechargedMobileNumber"] as? String
        self.retailAmount = json["retailAmount"] as? Double
        self.retailUnit = json["retailUnit"] as? String
        self.statusMessage = json["statusMessage"] as? String
        self.validityQuantity = json["validityQuantity"] as? Int
        self.validityUnit = json["validityUnit"] as? String
        self.wholesaleAmount = json["wholesaleAmount"] as? String
        self.wholesaleUnit = json["wholesaleUnit"] as? String
        self.firstStep_ActivityDate = json["firstStep_ActivityDate"] as? String
        self.secondStep_ActivityDate = json["secondStep_ActivityDate"] as? String
        self.finalStep_ActivityDate = json["finalStep_ActivityDate"] as? String
        self.usageInfo = json["usageInfo"] as? String
    }
}
