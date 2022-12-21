//
//  ReasonModel.swift
//  Altienco
//
//  Created by mac on 21/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct ReasonModel: Decodable {
    let description : String?
    let id : Int?
    let reason: String?
    init (json: [String:Any]) {
        self.description = json["description"] as? String
        self.id = json["id"] as? Int
        self.reason = json["reason"] as? String
    }
}
