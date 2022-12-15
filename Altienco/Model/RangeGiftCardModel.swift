//
//  RangeGiftCardModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
class RangeGiftCardResponse: Codable {
    var planID, validityQuantity: Int?
    var planName: String?
    var destinationAmount: DestinationAmount?
    var destinationUnit: String?
    var sourceAmount: Amount?
    var sourceUnit: String?
    var retailAmount: Amount?
    var retailUnit: String?
    var retailRates: Double?
    var wholesaleAmount: Amount?
    var wholesaleUnit, validityUnit, objDescription: String?
    var usageInfo: String?
    var operatorID: Int?
    var operatorName, planTypeName, currencySymbol: String?

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
        case planName, destinationAmount, destinationUnit, sourceAmount, sourceUnit, retailAmount, retailUnit, wholesaleAmount, wholesaleUnit, validityQuantity, validityUnit
        case objDescription = "description"
        case usageInfo
        case operatorID = "operatorId"
        case operatorName, planTypeName, currencySymbol, retailRates
    }

    init(json: [String: Any]) {
        self.planID = json["planID"] as? Int
        self.planName = json["planName"] as? String
        if let destinationAmount = json["destinationAmount"] as? [String : Any] {
            self.destinationAmount = DestinationAmount.init(json: destinationAmount)
        }
        self.destinationUnit = json["destinationUnit"] as? String
        if let sourceAmount = json["sourceAmount"] as? [String : Any] {
            self.sourceAmount = Amount.init(json: sourceAmount)
        }
        self.sourceUnit = json["sourceUnit"] as? String
        if let retailAmount = json["retailAmount"] as? [String : Any] {
            self.retailAmount = Amount.init(json: retailAmount)
        }
        self.retailUnit = json["retailUnit"] as? String
        if let wholesaleAmount = json["wholesaleAmount"] as? [String : Any] {
            self.wholesaleAmount = Amount.init(json: wholesaleAmount)
        }
        self.wholesaleUnit = json["wholesaleUnit"] as? String
        self.validityQuantity = json["validityQuantity"] as? Int
        self.validityUnit = json["validityUnit"] as? String
        self.objDescription = json["description"] as? String
        self.usageInfo = json["usageInfo"] as? String
        self.operatorID = json["operatorId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.planTypeName = json["planTypeName"] as? String
        self.currencySymbol = json["currencySymbol"] as? String
        self.retailRates = json["retailRates"] as? Double
    }
}

// MARK: - DestinationAmount
class DestinationAmount: Codable {
    var increment, max, min: Int?

    enum CodingKeys: String, CodingKey {
        case increment, max, min
    }
    init(json: [String: Any]) {
        self.increment = json["increment"] as? Int
        self.max = json["max"] as? Int
        self.min = json["min"] as? Int
    }
}

// MARK: - Amount
class Amount: Codable {
    var max, min: Double?
    enum CodingKeys: String, CodingKey {
        case max, min
    }
    init(json: [String: Any]) {
        self.max = json["max"] as? Double
        self.min = json["min"] as? Double
    }
}

