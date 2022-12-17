//
//  TransactionHistoryViewModel.swift
//  Altienco
//
//  Created by Ashish on 04/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class TransactionHistoryViewModel {
    
//    var historyList : Box<[HistoryResponseObj]> = Box([])
    func getTransactionHistory(model : HistoryRequestObj, complition : @escaping([HistoryResponseObj]?, Bool) -> Void)->Void{
        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.transactionHistory
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            var historyData = [HistoryResponseObj]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        historyData.append(HistoryResponseObj.init(json: dict as! [String : Any]))
                        }
                    
                    complition(historyData, true)
                    
                }
                else
                {
                    complition(nil, false)
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }

        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
        }
    }
}
