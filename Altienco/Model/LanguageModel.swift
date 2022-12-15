//
//  LanguageModel.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation

struct LanguageModel {
    let language : String?
    let pK_Language_ID : NSNumber?
    
    
    
    init(json : [String :  Any]) {
        self.language = json["language"] as? String
        self.pK_Language_ID = json["pK_Language_ID"] as? NSNumber
    }
    
    
}


class ErrorResponseObj: Codable {
    var type, message: String?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case message = "Message"
    }

    init(type: String?, message: String?) {
        self.type = type
        self.message = message
    }
}
