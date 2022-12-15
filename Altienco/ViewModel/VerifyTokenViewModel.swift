//
//  VerifyTokenViewModel.swift
//  LMDispatcher
//
//  Created by APPLE on 30/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class VerifyTokenViewModel {
    
    var signup : Box<UserModel> = Box(UserModel())
    func checkToken(model : VerifyToken,complition : @escaping(UserModel?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.verifyToken
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            
                if jsondata?["status_Code"] as? Int == 200, let data = jsondata?["data"] as? [String : Any] {
                    self.signup.value = UserModel.init(json: data as! [String : Any] )
                    let model = UserModel.init(json: data as! [String : Any])
                    UserDefaults.setUserData(data: model)
                    complition(self.signup.value)
                    
                }
                else{
                    Helper.showToast((jsondata?["message"] as? String)!, delay:Helper.DELAY_LONG)
                    complition(nil)
                }

        }) { (Error) in
            if let error = Error{
                Helper.showToast(error.debugDescription , delay:Helper.DELAY_LONG)
            }
            complition(nil)
        }
    }
}
