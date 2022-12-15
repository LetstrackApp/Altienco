//
//  VerifyOTPViewModel.swift
//  LMDispatcher
//
//  Created by APPLE on 15/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class VerifyOTPViewModel {
    var signup : Box<UserModel> = Box(UserModel())
    func callData(model : VerifyOTP, complition : @escaping(Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        debugPrint(json as Any)
        let strURl = subURL.verifyOTP
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            
            
            //            if let jsondata = JSONResponse as NSDictionary? {
            debugPrint("otp responce:", jsondata)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {  if resultData["status"] as? Bool == true{
                if let result = resultData["data"] as? [String: Any]{
                    if let isAvatarImage = result["isAvatarImage"] as? Bool{
                        UserDefaults.setAvtarImage(data: isAvatarImage)
                    }
                    if let api_Token = result["api_Token"] as? String{
                        UserDefaults.setToken(data: api_Token)
                    }
                    let model = UserModel.init(json: result )
                    self.signup.value = model
                    UserDefaults.setUserData(data: model)
                    UserDefaults.setToken(data: model.apiToken ?? "")
                    complition(true)
                }}
                else
                {
                    complition(false)
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }
            else
            {
                complition(false)
                Helper.showToast((jsondata?["Message"] as? String)!, delay:Helper.DELAY_LONG)
            }
        }) { (Error) in
            debugPrint(Error)
        }
    }
    
    
    
}


import Foundation
import Alamofire

class ResendOTPViewModel {
    var signup : Box<UserModel> = Box(UserModel())
    func callData(model : ResendOTP, complition : @escaping(Bool?, String) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        debugPrint(json as Any)
        let strURl = subURL.resendOTP
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            
            
            //            if let jsondata = JSONResponse as NSDictionary? {
            debugPrint("otp responce:", jsondata ?? [])
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary {
                if let status = resultData["status"] as? Bool, let msg = resultData["message"] as? String{
                    complition(status, msg)
                }
                else{
                    complition(false, "Please try after Sometime!")
                }
                
            }
            else
            {
                complition(false, "")
                //                    Helper.showToast((jsondata["message"] as? String)!, delay:Helper.DELAY_LONG)
            }
        }) { (Error) in
            debugPrint(Error)
        }
    }
    
    
    
}
