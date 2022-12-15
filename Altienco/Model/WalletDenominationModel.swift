//
//  WalletDenominationModel.swift
//  Altienco
//
//  Created by Deepak on 22/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct WalletDenominationRequest: Codable {
    var currencyCodes: String?

    enum CodingKeys: String, CodingKey {
        case currencyCodes = "currencyCode"
    }

}

class WalletDenominationResponse: Codable {
    var amountID, denominationValue: Int?
    var currencyCode, currencySymbol: String?

    enum CodingKeys: String, CodingKey {
        case amountID = "amount_Id"
        case denominationValue, currencyCode, currencySymbol
    }

    init(json: [String: Any]) {
        self.amountID = json["amount_Id"] as? Int
        self.denominationValue = json["denominationValue"] as? Int
        self.currencyCode = json["currencyCode"] as? String
        self.currencySymbol = json["currencySymbol"] as? String
    }
}

struct PaymentIntentRequest: Codable {
    var customerID: Int?
    var langCode: String?
    var amount: Int?
    var currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case langCode, amount, currencyCode
    }
}

struct PaymentIntentResponse: Codable {
    var paymentIntent, publishableKey: String?

    enum CodingKeys: String, CodingKey {
        case paymentIntent
        case publishableKey
    }
    init(json: [String: Any]) {
        self.paymentIntent = json["paymentIntent"] as? String
        self.publishableKey = json["publishableKey"] as? String
    }
}
struct VerifyPaymentRequest: Codable {
    var customerId: Int
    var clientSKey: String?

    enum CodingKeys: String, CodingKey {
        case customerId
        case clientSKey
    }
}


struct VerifyPaymentResponse: Codable {
    var WalletAmount: Double?
    var PaymentStatus: String?

    enum CodingKeys: String, CodingKey {
        case WalletAmount
        case PaymentStatus
    }
    init(json: [String: Any]) {
        self.WalletAmount = json["WalletAmount"] as? Double
        self.PaymentStatus = json["PaymentStatus"] as? String
    }
}
