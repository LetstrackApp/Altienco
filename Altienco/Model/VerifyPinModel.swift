//
//  VerifyPinModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct VerifyPinModel: Codable {
    let pinNumber, langCode: String
    let transactionTypeID: Int

    enum CodingKeys: String, CodingKey {
        case pinNumber = "PINNumber"
        case langCode
        case transactionTypeID = "transactionTypeId"
    }
}



struct VerifyPinResponseObj: Codable {
    let denominationPrice, cardValue: Int?
    
    enum CodingKeys: String, CodingKey {
        case denominationPrice = "denominationPrice"
        case cardValue = "cardValue"
    }
    
    init(json: [String: Any]){
        self.denominationPrice = json["denominationPrice"] as? Int
        self.cardValue = json["cardValue"] as? Int
    }
}
