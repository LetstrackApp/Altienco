//
//  OPeratorPlansModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

struct OPeratorPlansResponseObj: Codable {
    let currency, planName: String?
    let denominationValue: Int?
    let cartItemResponseObjDescription: JSONNull?

    enum CodingKeys: String, CodingKey {
        case currency, planName, denominationValue
        case cartItemResponseObjDescription = "description"
    }
    init(json: [String: Any]){
        self.currency = json["currency"] as? String
        self.planName = json["planName"] as? String
        self.denominationValue = json["denominationValue"] as? Int
        self.cartItemResponseObjDescription = json["description"] as? JSONNull
    }
}


typealias OPeratorResponseObj = [OPeratorPlansResponseObj]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

