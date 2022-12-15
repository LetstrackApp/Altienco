//
//  AdvertismentViewModel.swift
//  Altienco
//
//  Created by Ashish on 05/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class AdvertismentViewModel {
    
    func getAdData(model : AdvertismentRequestObj, complition : @escaping([AdvertismentResponseObj]?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.advertisment
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var advertismentData = [AdvertismentResponseObj]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        advertismentData.append(AdvertismentResponseObj.init(json: dict as! [String : Any]))
                        }
                    complition(advertismentData, true)
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
            if let error = Error{
                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
            complition(nil, false)
        }
    }
}
