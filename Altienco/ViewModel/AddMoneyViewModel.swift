//
//  AddMoneyViewModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class AddMoneyViewModel {
    
    
    func addMoney(model : AddMoneyModel, complition : @escaping(AddMoneyResponseObj?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.addMoney
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if let jsondata = resultData["data"] as! NSDictionary? {
                
                    let model = AddMoneyResponseObj.init(json: jsondata as! [String : Any])
                    if resultData["status"] as? Bool == true{
                    complition(model, true)
                    }
                    else{
                        complition(model, false)
                       // Helper.showToast((resultData["message"] as? String),isAlertView: false)
                    }
                }
                else
                {
                    complition(nil, false)
                   // Helper.showToast((resultData["message"] as? String),isAlertView: false)
                }
            }
                else{
                   // Helper.showToast((jsondata?["Message"] as? String),isAlertView: false)
                    complition(nil, false)
                }
        }) { (Error) in
            if let error = Error{
                Helper.showToast(error ,isAlertView: true)
            }
            //complition(nil, false)
        }
    }
}
