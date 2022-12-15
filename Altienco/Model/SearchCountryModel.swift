//
//  SearchCountryModel.swift
//  Altienco
//
//  Created by Ashish on 29/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

// MARK: - SearchCountryModel
class SearchCountryModel: Codable {
    let countryID: Int?
    let countryName, countryISOCode, countryISOCode2, mobileCode: String?
    let flagImg: JSONNull?

    enum CodingKeys: String, CodingKey {
        case countryID
        case countryName
        case countryISOCode, countryISOCode2
        case mobileCode
        case flagImg
    }

    init(json: [String: Any]) {
        self.countryID = json["country_id"] as? Int
        self.countryName = json["country_name"] as? String
        self.countryISOCode = json["country_iso_code"] as? String
        self.countryISOCode2 = json["country_iso2_code"] as? String
        self.mobileCode = json["mobile_code"] as? String
        self.flagImg = json["flag_img"] as? JSONNull
    }
}
