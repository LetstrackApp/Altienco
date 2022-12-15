//
//  OperatorListViewModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class OperatorListViewModel {
    
//    var operatorList : Box<[OperatorListResponseObj]> = Box([])
    
    func getOperator(countryID: Int, transactionTypeId: Int, langCode: String, complition : @escaping([OperatorListResponseObj]?, Bool?, String) -> Void)->Void{
        
        let strURL = subURL.getOperator + "/\(countryID)/\(transactionTypeId)/en"
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
            debugPrint(JSONResponse)
            if let data = JSONResponse as? NSDictionary {
                var operatorList = [OperatorListResponseObj]()
                if data["Message_Code"] as? Bool == true, let resultData = data["Result"] as? NSDictionary
                {
                    for dict in resultData["data"] as? Array ?? []{
                    operatorList.append(OperatorListResponseObj.init(json: dict as! [String : Any]))
                    }
                    complition(operatorList, true, "")
                }
                else{
                    if let message = data["message"] as? String{
                    complition(nil, false, message)
                    }
                }
            }else{
                complition(nil, false, "Oops, something went wrong. Please try again later. ")
            }
        }) {
            (error) -> Void in
            complition(nil, false, "Oops, something went wrong. Please try again later. ")
            debugPrint(error.localizedDescription)
        }
    }
}

