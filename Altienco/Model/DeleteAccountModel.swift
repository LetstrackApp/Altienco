//
//  DeleteAccountModel.swift
//  Altienco
//
//  Created by Deepak on 12/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation


struct DeleteAccountModel: Codable {
    var customerID: Int?
    var isUserDisabled: Bool?
    var disabledRemarks: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case isUserDisabled
        case disabledRemarks
    }
}
