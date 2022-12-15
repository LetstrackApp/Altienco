//
//  GiftCardModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
class GiftCardResponce: Codable {
    var operatorID: Int?
    var operatorName, countryCode: String?
    var isFeatured, isOccasions, isLuxury: Bool?
    var planTypeID: Int?
    var operatorImageURL: String?

    enum CodingKeys: String, CodingKey {
        case operatorID = "operatorId"
        case operatorName, countryCode, isFeatured, isOccasions, isLuxury
        case planTypeID = "planTypeId"
        case operatorImageURL = "operatorImageUrl"
    }

    init( json: [String: Any]) {
        self.operatorID = json["operatorId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.countryCode = json["countryCode"] as? String
        self.isFeatured = json["isFeatured"] as? Bool
        self.isOccasions = json["isOccasions"] as? Bool
        self.isLuxury = json["isLuxury"] as? Bool
        self.planTypeID = json["planTypeId"] as? Int
        self.operatorImageURL = json["operatorImageUrl"] as? String
    }
}
