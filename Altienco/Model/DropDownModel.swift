//
//  DropDownModel.swift
//  Altienco
//
//  Created by Ashish on 04/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct DropDownRequestModel: Codable {
    var customerID, dropdownID: Int?
    var langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case dropdownID = "dropdownId"
        case langCode
    }
}

class DropDownResponseObj: Codable {
    var id: Int?
    var name: String?

    init(json: [String: Any]) {
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
    }
}
