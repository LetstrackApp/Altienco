//
//  DeleteAccountViewModel.swift
//  Altienco
//
//  Created by Deepak on 12/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class DeleteAccountViewModel {
    func disabledUser(model : DeleteAccountModel, complition : @escaping(Bool?, String) -> Void)->Void{
        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.deactivateAccount
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
                    if let message = resultData["message"] as? String{
                    complition(true, message)
                    }}
                else
                {
                    if let message = resultData["message"] as? String{
                    complition(false, message)
                    }
                }
            }
            else if let message = jsondata?["message"] as? String{
                    complition(false, message)
                    }
        }) { (Error) in
            if let error = Error{
                SVProgressHUD.dismiss()
                complition(false, error.description)
            }
            
        }
    }
}
