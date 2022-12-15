//
//  UsedMarkModel.swift
//  Altienco
//
//  Created by Ashish on 04/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct UsedMarkModel: Codable {
    var customerID, voucherID: String?
    var isUsed: Bool?
    var langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case voucherID = "voucherId"
        case isUsed, langCode
    }
}
