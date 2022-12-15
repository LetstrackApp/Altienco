//
//  RegistrationViewModel.swift
//  Altienco
//
//  Created by Ashish on 02/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class RegistrationViewModel {
    
//    var signup : Box<UserModel> = Box(UserModel())
    
    func registerUser(model : RegistrationModel, complition : @escaping(UserModel?, Bool, String) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.registration
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        SVProgressHUD.show()
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {  if resultData["status"] as? Bool == true{
                if let jsondata = resultData["data"] as! NSDictionary? {
                
                    if let isAvatarImage = jsondata["isAvatarImage"] as? Bool{
                        UserDefaults.setAvtarImage(data: isAvatarImage)
                    }
                    if let isExistingUser = jsondata["isExistingUser"] as? Bool{
                    UserDefaults.setExistingUser(data: isExistingUser)
                    }
//                    self.signup.value = UserModel.init(json: jsondata as! [String : Any] )
                    let model = UserModel.init(json: jsondata as! [String : Any])
                    UserDefaults.setUserData(data: model)
                    complition(model, true, "")
                }}
                else
                {
                    if let message = resultData["message"] as? String{
                    complition(nil, false, message)
                    }
                }
            }

                else{
                    
                    if let message = jsondata?["Message"] as? String{
                    complition(nil, false, message)
                    }
                }

        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                complition(nil, false, error.description)
//                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
            
        }
    }
}
