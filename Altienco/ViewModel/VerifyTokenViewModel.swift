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
            
                if jsondata?["status_Code"] as? Int == 200,
                   let data = jsondata?["data"] as? [String : Any] {
                    self.signup.value = UserModel.init(json: data as! [String : Any] )
                    let model = UserModel.init(json: data as! [String : Any])
                    UserDefaults.setUserData(data: model)
                    complition(self.signup.value)
                    
                }
            else if  let message = jsondata?["message"] as? String {
                Helper.shared.showAlertView(message: message)
                complition(nil)
            }
            else {
                Helper.shared.showAlertView(message: lngConst.supportMsg)
                complition(nil)
            }


        }) { (Error) in
            if let error = Error{
                Helper.shared.showAlertView(message: error.debugDescription)
            }
            complition(nil)
        }
    }
}
