//
//  AddMoneyModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct AddMoneyModel: Codable {
    let pinNumber, langCode: String
    let transactionTypeID, customerId: Int

    enum CodingKeys: String, CodingKey {
        case pinNumber = "PINNumber"
        case langCode
        case customerId = "customerId"
        case transactionTypeID = "transactionTypeId"
    }
}



struct AddMoneyResponseObj: Codable {
    let denominationPrice, cardValue: Int?
    let walletAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case denominationPrice = "denominationPrice"
        case cardValue = "cardValue"
        case walletAmount = "walletAmount"
    }
    
    init(json: [String: Any]){
        self.denominationPrice = json["denominationPrice"] as? Int
        self.cardValue = json["cardValue"] as? Int
        self.walletAmount = json["walletAmount"] as? Double
    }
}
