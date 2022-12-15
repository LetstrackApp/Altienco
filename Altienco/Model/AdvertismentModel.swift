//
//  AdvertismentModel.swift
//  Altienco
//
//  Created by Ashish on 05/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation


struct AdvertismentRequestObj: Codable {
    var customerID: Int?
    var screenID, langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case screenID = "screenId"
        case langCode
    }
}

class AdvertismentResponseObj: Codable {
    var id: Int?
    var thumbnail: String?
    var urlPath, title, details: JSONNull?
    var contentType, screenID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case thumbnail, urlPath, title, details, contentType, screenID
    }

    init(json: [String: Any]) {
        self.id = json["id"] as? Int
        self.thumbnail = json["thumbnail"] as? String
        self.urlPath = json["urlPath"] as? JSONNull
        self.title = json["title"] as? JSONNull
        self.details = json["details"] as? JSONNull
        self.contentType = json["contentType"] as? Int
        self.screenID = json["screenID"] as? Int
    }
}
