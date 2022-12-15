//
//  IntrOperatorPlanViewModel.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class IntrOperatorPlanViewModel {
    
    func getOperator(model : IntroperatorPlanRequestObj, complition : @escaping([LastRecharge]?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.intrOperatorPlans
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        SVProgressHUD.show()
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            var lastRecharge = [LastRecharge]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        lastRecharge.append(LastRecharge.init(json: dict as! [String : Any]))
                    }
                    complition(lastRecharge)
                }
                else
                {
                    complition(nil)
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
                
            }

                else{
                    Helper.showToast((jsondata?["Message"] as? String)!, delay:Helper.DELAY_LONG)
                }

        }) { (Error) in
            SVProgressHUD.dismiss()
//            Helper.showToast(Error?.debugDescription ?? "", delay:Helper.DELAY_LONG)
            if let error = Error{
                complition(nil)
            }
        }
    }
}


