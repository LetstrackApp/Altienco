//
//  IntroperatorPlan.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
class IntroperatorPlanRequestObj: Codable {
    var operatorID: Int?
    var countryCode, mobileCode, mobileNumber, langCode: String?

    enum CodingKeys: String, CodingKey {
        case operatorID = "operatorId"
        case countryCode, mobileCode, mobileNumber, langCode
    }

    init(operatorID: Int?, countryCode: String?, mobileCode: String?, mobileNumber: String?, langCode: String?) {
        self.operatorID = operatorID
        self.countryCode = countryCode
        self.mobileCode = mobileCode
        self.mobileNumber = mobileNumber
        self.langCode = langCode
    }
}
