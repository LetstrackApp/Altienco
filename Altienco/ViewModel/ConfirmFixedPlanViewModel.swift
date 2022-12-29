//
//  ConfirmFixedPlanViewModel.swift
//  Altienco
//
//  Created by Deepak on 14/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class ConfirmFixedPlanViewModel {
    
    func setFixedPlan(model : ConfirmFixedPlanRequest, complition : @escaping(ConfirmIntrResponseObj?, Bool?) -> Void)->Void{
//        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.confirmingGiftCard
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    if let data = resultData["data"] as! NSDictionary? {
                        let resultData = ConfirmIntrResponseObj.init(json: data as! [String : Any])
                        complition(resultData, true)
                    }
                    
                }
                else
                {
                    complition(nil, false)
                    Helper.showToast((resultData["message"] as? String),isAlertView: true)
                }
                complition(nil, false)
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }

        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error , isAlertView: true)
            }
        }
    }
}

class ConfirmRangePlanViewModel {
    
    func setRangePlan(model : ConfirmRangePlanRequest, complition : @escaping(ConfirmIntrResponseObj?,String?, Bool?) -> Void)->Void{
        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.confirmingGiftCard
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    if let data = resultData["data"] as! NSDictionary? {
                        let resultData = ConfirmIntrResponseObj.init(json: data as! [String : Any])
                        complition(resultData,"", true)
                    }
                    
                }
                else
                {
                    complition(nil, (resultData["message"] as? String)!,false)
                    
                }
                
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }

        }) { (Error) in
            if let error = Error{
                SVProgressHUD.dismiss()
                complition(nil, error.description,false)
//                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
        }
    }
}


