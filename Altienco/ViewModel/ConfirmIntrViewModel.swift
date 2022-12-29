//
//  ConfirmIntrViewModel.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class ConfirmIntrViewModel {
    
    func confirmRecharge(model : ConfirmIntrRequestObj,
                         complition : @escaping(ConfirmIntrResponseObj?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.intrConfirmRecharge
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
//        SVProgressHUD.show()
        debugPrint("subURL.intrConfirmRecharge",json);
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            SVProgressHUD.dismiss()
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
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG,isAlertView:true)
                }
                complition(nil, false)
            }

                else{
                    complition(nil, false)
                    Helper.showToast((jsondata?["Message"] as? String)!, delay:Helper.DELAY_LONG,isAlertView:true)
                }

        }) { (Error) in
            SVProgressHUD.dismiss()
            Helper.showToast(Error?.debugDescription ?? "",
                             delay:Helper.DELAY_LONG,isAlertView:true)
            if let error = Error {
                complition(nil, false)
//                Helper.showToast(error.lowercased(), delay:Helper.DELAY_LONG)
            }
        }
    }
}


