//
//  OperatorListModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

// MARK: - CartItemResponseObjElement
struct OperatorListResponseObj: Codable {
    let operatorID: Int?
    let operatorName: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case operatorID = "operatorId"
        case operatorName
        case imageURL = "imageUrl"
    }
    init(json: [String: Any]){
        self.operatorID = json["operatorId"] as? Int
        self.operatorName = json["operatorName"] as? String
        self.imageURL = json["imageUrl"] as? String
    }
}

typealias CartItemResponseObj = [OperatorListResponseObj]
