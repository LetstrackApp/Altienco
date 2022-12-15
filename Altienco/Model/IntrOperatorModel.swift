//
//  IntrOperatorModel.swift
//  Altienco
//
//  Created by Ashish on 29/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct IntrOperatorRequestObj: Codable {
    let countryID: Int
    let mobileCode, mobileNumber: String
    let customerID: Int
    let langCode: String

    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case mobileCode, mobileNumber
        case customerID = "customerId"
        case langCode
    }
}


struct IntrOperatorResponseObj: Codable {
    var operatorList: [OperatorList]?
    var lastRecharge: [LastRecharge]?

    enum CodingKeys: String, CodingKey {
        case operatorList = "operatorList"
        case lastRecharge = "LastRecharge"
    }
    init(){
        
    }
    
    init(json: [String: Any]) {
        self.operatorList = json["operatorList"] as? [OperatorList]
        self.lastRecharge = json["LastRecharge"] as? [LastRecharge]
    }
    
}
// MARK: - LastRecharge
struct LastRecharge: Codable {
    var planID, validityQuantity: Int?
    var destinationUnit: String?
    var retailAmount, destinationAmount, wholesaleAmount: Double?
    var retailUnit, validityUnit, lastRechargeDescription, wholesaleUnit: String?
    var data: String?

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
        case destinationAmount, destinationUnit
        case retailAmount = "retailAmount"
        case wholesaleAmount = "wholesaleAmount"
        case retailUnit
        case wholesaleUnit
        case validityQuantity = "validityQuantity"
        case validityUnit
        case lastRechargeDescription = "description"
        case data
    }

    init(json: [String: Any]) {
        self.planID = json["planId"] as? Int
        self.destinationAmount = json["destinationAmount"] as? Double
        self.destinationUnit = json["destinationUnit"] as? String
        self.retailAmount = json["retailAmount"] as? Double
        self.wholesaleAmount = json["wholesaleAmount"] as? Double
        self.retailUnit = json["retailUnit"] as? String
        self.wholesaleUnit = json["wholesaleUnit"] as? String
        self.validityQuantity = json["validityQuantity"] as? Int
        self.validityUnit = json["validityUnit"] as? String
        self.lastRechargeDescription = json["description"] as? String
        self.data = json["data"] as? String
    }
}

// MARK: - OperatorList
struct OperatorList: Codable {
    var operatorID, providerID, providerAPIID: Int?
    var operatorName: String?
    var countryID: Int?
    var countryCode: String?
    var imageURL: JSONNull?
    var operatorCategory: Int?
    var isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case operatorID = "operatorId"
        case providerID = "providerId"
        case providerAPIID = "providerApiId"
        case operatorName
        case countryID = "countryId"
        case countryCode
        case imageURL = "imageUrl"
        case operatorCategory, isDefault
    }

    init(json: [String: Any]) {
        self.operatorID = json["operatorId"] as? Int
        self.providerID = json["providerId"] as? Int
        self.providerAPIID = json["providerApiId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.countryID = json["countryId"] as? Int
        self.countryCode = json["countryCode"] as? String
        self.imageURL = json["imageUrl"] as? JSONNull
        self.operatorCategory = json["operatorCategory"] as? Int
        self.isDefault = json["isDefault"] as? Bool
    }
}

