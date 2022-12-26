//
//  IntrOperatorViewModel.swift
//  Altienco
//
//  Created by Ashish on 29/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class IntrOperatorViewModel {
    
//    var operatorList : Box<IntrOperatorResponseObj> = Box(IntrOperatorResponseObj())
    func getOperator(model : IntrOperatorRequestObj, complition : @escaping([LastRecharge]?, [OperatorList]?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.intrOperator
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        debugPrint("subURL.intrOperator",json)
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            var operatorList = [OperatorList]()
            var lastRecharge = [LastRecharge]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    if let jsondata = resultData["data"] as! NSDictionary? {
                        for dict in jsondata["LastRecharge"] as? Array ?? []{
                            lastRecharge.append(LastRecharge.init(json: dict as! [String : Any]))
                        }
                        for dict in jsondata["operatorList"] as? Array ?? []{
                            operatorList.append(OperatorList.init(json: dict as! [String : Any]))
                        }
                        complition(lastRecharge, operatorList)
                    }else {
                        complition(nil, nil)
                    }
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                    complition(nil, nil)
                }
                
            }

                else{
                    complition(nil, nil)
                    Helper.showToast((jsondata?["Message"] as? String),isAlertView: true)
                }

        }) { (Error) in
            complition(nil, nil)
            if let error = Error{
//                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
        }
    }
}


