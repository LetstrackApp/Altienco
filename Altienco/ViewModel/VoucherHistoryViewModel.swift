//
//  VoucherHistoryViewModel.swift
//  Altienco
//
//  Created by Ashish on 09/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class VoucherHistoryViewModel {
    
    var historyList : Box<[VoucherHistoryResponseObj]> = Box([])
    func getHistory(model : VoucherHistoryRequestObj,completion:@escaping(Bool)->Void) {
//        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.voucherHistory
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            var historyList = [VoucherHistoryResponseObj]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        historyList.append(VoucherHistoryResponseObj.init(json: dict as! [String : Any]))
                        }
                    self.historyList.value = historyList
                }
                else
                {
//                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
                
            }
            completion(true)


        }) { (Error) in
            SVProgressHUD.dismiss()
            completion(false)

            if let error = Error{
//                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
        }
    }
}

