//
//  OPeratorPlansViewModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class OPeratorPlansViewModel {
    
    //    var operatorPlanList : Box<[OPeratorPlansResponseObj]> = Box([])
    
    func getOperatorPlans(OperatorID: Int, transactionTypeId: Int, langCode: String, complition : @escaping([OPeratorPlansResponseObj]?, Bool?, String) -> Void)->Void{
        SVProgressHUD.show()
        let strURL = subURL.getOperatorPlans + "/\(OperatorID)/\(transactionTypeId)/en"
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        debugPrint("strURL",strURL)
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            
            (JSONResponse) -> Void in
            SVProgressHUD.dismiss()
            if let data = JSONResponse as? NSDictionary {
                var operatorList = [OPeratorPlansResponseObj]()
                if data["Message_Code"] as? Bool == true,
                   let result = data["Result"] as? NSDictionary {
                    if result["status"] as? Bool == true {
                        if let resultData = result["data"] as? NSDictionary{
                            for dict in resultData["planList"] as? Array ?? []{
                                operatorList.append(OPeratorPlansResponseObj.init(json: dict as! [String : Any]))
                            }
                        }
                        complition(operatorList, true, "")
                    }
                    else {
                        if let message = result["message"] as? String{
                            complition(nil, false, message)
                        }
                    }
                }
                else{
                    complition(nil, false, lngConst.supportMsg)
                }
            }
        }) {
            
            (error) -> Void in
            SVProgressHUD.dismiss()
            complition(nil, false, lngConst.supportMsg)
            debugPrint(error.localizedDescription)
        }
    }
}

