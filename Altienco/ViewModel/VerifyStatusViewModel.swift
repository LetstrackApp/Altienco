//
//  VerifyStatusViewModel.swift
//  Altienco
//
//  Created by Deepak on 27/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class VerifyStatusViewModel {
    func verifyProcessStatus(model : VerifyStatusRequest,
                             complition : @escaping(VerifyStatusResponce?, Bool?) -> Void)->Void{
        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.verifyCallbackStatus
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                SVProgressHUD.dismiss()
                if resultData["status"] as? Bool == true{
                    if let data = resultData["data"] as! NSDictionary? {
                        let resultData = VerifyStatusResponce.init(json: data as! [String : Any])
                        complition(resultData, true)
                    }
                    else{
                        complition(nil, false)
                    }
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                    complition(nil, false)
                }
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }
        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
            complition(nil, false)
        }
    }
}
