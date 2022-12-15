//
//  LanguageViewModel.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class LanguageViewModel {
    
    var language : Box<[LanguageModel]> = Box([])
    
    func getLanguage() {
        let strURL = subURL.languageList
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
//            debugPrint(JSONResponse)
            if let data = JSONResponse as? NSDictionary {
                var languageModel = [LanguageModel]()
                if data["status_Code"] as? Int == 200
                {
                for dict in data["data"] as? Array ?? []{
                    languageModel.append(LanguageModel.init(json: dict as! [String : Any]))
                    }
                self.language.value = languageModel
                }
                else{
//                    Helper.showToast((data["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }
        }) {
            (error) -> Void in
            debugPrint(error.localizedDescription)
        }
    }
}
