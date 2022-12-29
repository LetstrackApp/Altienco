//
//  HistoryViewModel.swift
//  Altienco
//
//  Created by Ashish on 09/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class HistoryViewModel {
    
    var historyList : Box<[HistoryResponseObj]> = Box([])
    func getHistory(model : HistoryRequestObj,
                    completion:@escaping(Bool)->Void) {
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.history
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
//            debugPrint("jsondata:", strURl, jsondata as Any)
            var historyData = [HistoryResponseObj]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        historyData.append(HistoryResponseObj.init(json: dict as! [String : Any]))
                        }
                    self.historyList.value.append(contentsOf: historyData)
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String), isAlertView: true)
                }
            }
            completion(true)

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }

        }) { (Error) in
            if let error = Error{
                SVProgressHUD.dismiss()
                Helper.showToast(error , isAlertView: true)
            }
            completion(false)

        }
    }
}

