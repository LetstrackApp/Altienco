//
//  HistoryModel.swift
//  Altienco
//
//  Created by Ashish on 09/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation


import Foundation

// MARK: - CartItemResponseObj

struct HistoryRequestObj: Codable {
    let customerId: Int?
    let pageNum: Int?
    let pageSize: Int?
    let langCode: String?
    let transactionTypeId: Int?

    enum CodingKeys: String, CodingKey {
        case customerId
        case langCode, transactionTypeId
        case pageNum, pageSize
    }
}
// MARK: - CartItemResponseObj

struct HistoryResponseObj: Codable {
    let transactionType, transactionMessage, orderNumber: String?
    var transactionStatus: Bool? = false
    let currency: String?
    let amount: Double?
    let transactionDate, planName, operatorName: String?
    let operatorID, customerID, transactionTypeID: Int?
    
    let processStatusId: Int?
    let countryCode, externalId: String?
    
    enum CodingKeys: String, CodingKey {
        case transactionType, transactionMessage, orderNumber, transactionStatus, currency, amount, transactionDate, planName, operatorName
        case operatorID
        case customerID
        case transactionTypeID
        case processStatusId, externalId
        case countryCode
    }

    init(json: [String: Any]) {
        self.transactionType =  json["transactionType"] as? String
        self.transactionMessage = json["transactionMessage"] as? String
        self.orderNumber = json["orderNumber"] as? String
        self.transactionStatus = json["transactionStatus"] as? Bool
        self.currency = json["currency"] as? String
        self.amount = json["amount"] as? Double
        self.transactionDate = json["transactionDate"] as? String
        self.planName = json["planName"] as? String
        self.operatorName = json["operatorName"] as? String
        self.operatorID = json["operatorId"] as? Int
        self.customerID = json["customerId"] as? Int
        self.transactionTypeID = json["transactionTypeId"] as? Int
        
        self.countryCode = json["countryCode"] as? String
        self.processStatusId = json["processStatusId"] as? Int
        self.externalId = json["externalId"] as? String
    }
}


