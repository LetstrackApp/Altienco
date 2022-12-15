//
//  LMViewModel.swift
//  LMRider
//
//  Created by APPLE on 14/01/21.
//  Copyright © 2021 Letstrack. All rights reserved.
//

//import Foundation
//import Alamofire
//
//class LMViewModel {
//    
//    func locActivity(model : LModeModel, complition : @escaping(Bool?) -> Void)->Void{
//        let data = try? JSONEncoder().encode(model)
//        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
//        debugPrint(json as Any)
//        let strURl = subURL.locationMode
//        let header : HTTPHeaders = ["Content-Type":"application/json"]
//        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (JSONResponse) in
//            if let jsondata = JSONResponse as NSDictionary? {
//                debugPrint("jsondata:", jsondata)
//                if jsondata["status_Code"] as? Int == 200{
//                    if let message = jsondata["message"] as? String
//                    {
//                     Helper.showToast(message, delay:Helper.DELAY_LONG)
//                    }
//                    complition(true)
//                }
//                else{
//                    if let message = jsondata["message"] as? String
//                    {
////                     Helper.showToast(message, delay:Helper.DELAY_LONG)
//                    }
//                    complition(nil)
//                }
//            }
//            else{
//                complition(nil)
//            }
//        }) { (Error) in
//            if let error = Error{
////                Helper.showToast(error , delay:Helper.DELAY_LONG)
//            }
//            complition(nil)
//        }
//    }
//}
