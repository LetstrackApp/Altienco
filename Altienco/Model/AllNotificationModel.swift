//
//  AllNotificationModel.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation


struct AllNotificationRequest: Codable {
    var customerID: Int?
    var langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case langCode
    }
}
class AllNotificationResponce: Codable {
    var notificationID, transactionTypeID: Int?
    var title, details, notificationDate: String?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case transactionTypeID = "transactionTypeId"
        case title, details, notificationDate
    }

    init(json: [String: Any]) {
        self.notificationID = json["notificationId"] as? Int
        self.transactionTypeID = json["transactionTypeId"] as? Int
        self.title = json["title"] as? String
        self.details = json["details"] as? String
        self.notificationDate = json["notificationDate"] as? String
    }
}


class NewNotificationResponse: Codable {
    var anyNewNotification: Bool?
    var currencySymbol: String?
    var amount: Double?

    init(json: [String: Any]) {
        self.anyNewNotification = json["anyNewNotification"] as? Bool
        self.currencySymbol = json["currencySymbol"] as? String
        self.amount = json["amount"] as? Double
    }
}

// JSONSchemaSupport.swift
