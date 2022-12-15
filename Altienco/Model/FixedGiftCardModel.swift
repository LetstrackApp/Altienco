//
//  FixedGiftCardModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
class FixedGiftResponseObj: Codable {
    var planID: Int?
    var planName: String?
    var destinationAmount: Int?
    var destinationUnit: String?
    var sourceAmount: Double?
    var sourceUnit: String?
    var retailAmount: Double?
    var retailUnit: String?
    var wholesaleAmount: Double?
    var wholesaleUnit: String?
    var validityQuantity: Int?
    var validityUnit, objDescription: String?
    var usageInfo: [String]?
    var operatorID: Int?
    var operatorName, planTypeName, currencySymbol: String?

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
        case planName, destinationAmount, destinationUnit, sourceAmount, sourceUnit, retailAmount, retailUnit, wholesaleAmount, wholesaleUnit, validityQuantity, validityUnit
        case objDescription = "description"
        case usageInfo
        case operatorID = "operatorId"
        case operatorName, planTypeName, currencySymbol
    }

    init(json: [String: Any]) {
        self.planID = json["planId"] as? Int
        self.planName = json["planName"] as? String
        self.destinationAmount = json["destinationAmount"] as? Int
        self.destinationUnit = json["destinationUnit"] as? String
        self.sourceAmount = json["sourceAmount"] as? Double
        self.sourceUnit = json["sourceUnit"] as? String
        self.retailAmount = json["retailAmount"] as? Double
        self.retailUnit = json["retailUnit"] as? String
        self.wholesaleAmount = json["wholesaleAmount"] as? Double
        self.wholesaleUnit = json["wholesaleUnit"] as? String
        self.validityQuantity = json["validityQuantity"] as? Int
        self.validityUnit = json["validityUnit"] as? String
        self.objDescription = json["description"] as? String
        self.usageInfo = json["usageInfo"] as? [String]
        self.operatorID = json["operatorId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.planTypeName = json["planTypeName"] as? String
        self.currencySymbol = json["currencySymbol"] as? String
    }
}
