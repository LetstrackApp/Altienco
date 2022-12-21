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

struct ResasonSubmit: Encodable {
    let userId: Int?
    let requesterName: String?
    let requesterEmail: String?
    let requesterMobile: String?
    let requesterReasonId: Int?
    let requesterRemarks: String?
    let attachmentPath: String?
    let orderId: String?
    init (userId: Int?,
          requesterName: String?,
          requesterEmail: String?,
          requesterMobile: String?,
          requesterReasonId: Int?,
          requesterRemarks: String?,
          attachmentPath: String?,
          orderId: String?){
        self.userId = userId
        self.requesterName = requesterName
        self.requesterEmail = requesterEmail
        self.requesterMobile = requesterMobile
        self.requesterReasonId = requesterReasonId
        self.requesterRemarks = requesterRemarks
        self.attachmentPath = attachmentPath
        self.orderId = orderId
        
    }
     
}

