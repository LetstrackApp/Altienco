//
//  ConfirmFixedPlanModel.swift
//  Altienco
//
//  Created by Deepak on 14/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
struct ConfirmFixedPlanRequest: Codable {
    var customerID: Int?
    var mobileCode, mobileNumber: String?
    var planID: Int?
    var planName: String?
    var planTypeID, operatorID: Int?
    var operatorName: String?
    var amountWithinRetailRange: String?
    var destinationAmount: Int?
    var destinationMaxAmount: Int?
    var destinationMinAmount: Int?
    var destinationUnit: String?
    var sourceMaxAmount, sourceMinAmount: String?
    var sourceUnit: String?
    var retailAmount: Int?
    var retailMaxAmount, retailMinAmount: String?
    var retailUnit: String?
    var wholesaleAmount: Double?
    var wholesaleMaxAmount: String?
    var wholesaleMinAmount: String?
    var wholesaleUnit, validityQuantity, validityUnit, cartItemResponseObjDescription: String?
    var langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case mobileCode, mobileNumber
        case planID = "planId"
        case planName
        case planTypeID = "planTypeId"
        case operatorID = "operatorId"
        case operatorName, amountWithinRetailRange, destinationAmount, destinationMaxAmount, destinationMinAmount, destinationUnit, sourceMaxAmount, sourceMinAmount, sourceUnit, retailAmount, retailMaxAmount, retailMinAmount, retailUnit, wholesaleAmount, wholesaleMaxAmount, wholesaleMinAmount, wholesaleUnit, validityQuantity, validityUnit
        case cartItemResponseObjDescription = "description"
        case langCode
    }

    init(customerID: Int?, mobileCode: String?, mobileNumber: String?, planID: Int?, planName: String?, planTypeID: Int?, operatorID: Int?, operatorName: String?, amountWithinRetailRange: String? = "", destinationAmount: Int?, destinationMaxAmount: Int?, destinationMinAmount: Int?, destinationUnit: String?, sourceMaxAmount: String? = "" , sourceMinAmount: String? = "", sourceUnit: String?, retailAmount: Int?, retailMaxAmount: String? = "", retailMinAmount: String? = nil, retailUnit: String?, wholesaleAmount: Double?, wholesaleMaxAmount: String? = "", wholesaleMinAmount: String? = "", wholesaleUnit: String?, validityQuantity: String?, validityUnit: String?, cartItemResponseObjDescription: String?, langCode: String?) {
        self.customerID = customerID
        self.mobileCode = mobileCode
        self.mobileNumber = mobileNumber
        self.planID = planID
        self.planName = planName
        self.planTypeID = planTypeID
        self.operatorID = operatorID
        self.operatorName = operatorName
        self.amountWithinRetailRange = amountWithinRetailRange
        self.destinationAmount = destinationAmount
        self.destinationMaxAmount = destinationMaxAmount
        self.destinationMinAmount = destinationMinAmount
        self.destinationUnit = destinationUnit
        self.sourceMaxAmount = sourceMaxAmount
        self.sourceMinAmount = sourceMinAmount
        self.sourceUnit = sourceUnit
        self.retailAmount = retailAmount
        self.retailMaxAmount = retailMaxAmount
        self.retailMinAmount = retailMinAmount
        self.retailUnit = retailUnit
        self.wholesaleAmount = wholesaleAmount
        self.wholesaleMaxAmount = wholesaleMaxAmount
        self.wholesaleMinAmount = wholesaleMinAmount
        self.wholesaleUnit = wholesaleUnit
        self.validityQuantity = validityQuantity
        self.validityUnit = validityUnit
        self.cartItemResponseObjDescription = cartItemResponseObjDescription
        self.langCode = langCode
    }
}


struct ConfirmRangePlanRequest: Codable {
    let customerID: Int?
    let mobileCode, mobileNumber: String?
    let planID: Int?
    let planName: String?
    let planTypeID, operatorID: Int?
    let operatorName: String?
    let amountWithinRetailRange: Double?
    let destinationAmount: String?
    let destinationMaxAmount, destinationMinAmount: Int?
    let destinationUnit: String?
    let sourceMaxAmount, sourceMinAmount: Double?
    let sourceUnit, retailAmount: String?
    let retailMaxAmount, retailMinAmount: Double?
    let retailUnit, wholesaleAmount: String?
    let wholesaleMaxAmount, wholesaleMinAmount: Double?
    let wholesaleUnit, validityQuantity, validityUnit, cartItemResponseObjDescription: String?
    let langCode: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case mobileCode, mobileNumber
        case planID = "planId"
        case planName
        case planTypeID = "planTypeId"
        case operatorID = "operatorId"
        case operatorName, amountWithinRetailRange, destinationAmount, destinationMaxAmount, destinationMinAmount, destinationUnit, sourceMaxAmount, sourceMinAmount, sourceUnit, retailAmount, retailMaxAmount, retailMinAmount, retailUnit, wholesaleAmount, wholesaleMaxAmount, wholesaleMinAmount, wholesaleUnit, validityQuantity, validityUnit
        case cartItemResponseObjDescription = "description"
        case langCode
    }

}
