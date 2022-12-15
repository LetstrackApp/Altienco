//
//  SelectCountryModel.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

//   import Foundation
//   import Alamofire
//
//class SelectCountryModel {
//    
//    func callData(model : SelectContry, complition : @escaping(Bool?, Int) -> Void)->Void{
//        let data = try? JSONEncoder().encode(model)
//        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
//        debugPrint(json as Any)
//        let strURl = subURL.signUp
//        let header : HTTPHeaders = ["Content-Type":"application/json"]
//
//        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (JSONResponse) in
//            if let data = JSONResponse as NSDictionary? {
//                debugPrint(data)
//                if data["status_Code"] as? Int == 200
//                {
//                if let userid = data["data"] as? Int{
//                complition(true, userid)
//                    
//                    }
//                }
//                else{
////                   Helper.showToast((data["message"] as? String)!, delay:Helper.DELAY_LONG)
//                    complition(nil, 0)
//                  
//                }
//            }
//            
//        }) { (Error) in
//            debugPrint(Error as Any)
//            complition(nil, 0)
//        }
//            }
//    
//    
//}
//
//
//
//
