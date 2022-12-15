//
//  CancelReason.swift
//  LMRider
//
//  Created by APPLE on 08/01/21.
//  Copyright © 2021 Letstrack. All rights reserved.
//

import Foundation

class CancelReason: Codable {
    let id: Int?
    let value, extraDetails: String?

    init(json: [String: Any]) {
        self.id = json["id"] as? Int
        self.value = json["value"] as? String
        self.extraDetails = json["extraDetails"] as? String
    }
}

typealias reason = [CancelReason]
