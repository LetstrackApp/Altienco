//
//  RecentTransactionViewModel.swift
//  Altienco
//
//  Created by mac on 20/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
enum isKind{
    case voucher
    case recharge
}

protocol RecentTransactionAPI {
    var kind : isKind?  {get set }
    var historyList : Box<[VoucherHistoryResponseObj]> {get set }
    
    func callHistoryData()
}

class RecentTransactionViewModel {
    var kind : isKind?
    var historyList : Box<[VoucherHistoryResponseObj]> = Box([])
}


extension  RecentTransactionViewModel : RecentTransactionAPI {
    
    func callHistoryData() {
        if let customerID = UserDefaults.getUserData?.customerID {
            let model = VoucherHistoryRequestObj.init(customerId: "\(customerID)", isRequiredAll: false,
                                                      langCode: "en",
                                                      operatorId: 0,
                                                      pinBankUsedStatus: 0,
                                                      pageNum: 0,
                                                      pageSize: 5,
                                                      transactionTypeId: 2)
            let data = try? JSONEncoder().encode(model)
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            let strURl = subURL.voucherHistory
            let header : HTTPHeaders = [
                "Authorization": "Bearer \(UserDefaults.getToken)",
                "Content-Type": "application/json"
            ]
            AFWrapper.requestPOSTURL(strURl,
                                     params: json,
                                     headers: header,
                                     success: { (jsondata) in
                debugPrint("jsondata:", strURl, jsondata as Any)
                var historyList = [VoucherHistoryResponseObj]()
                if jsondata?["Message_Code"] as? Bool == true,
                   let resultData = jsondata?["Result"] as? NSDictionary {
                    if resultData["status"] as? Bool == true {
                        for dict in resultData["data"] as? Array ?? [] {
                            historyList.append(VoucherHistoryResponseObj.init(json: dict as! [String : Any]))
                        }
                        self.historyList.value = historyList
                    }
                }
            }) { (Error) in

            }
        }
    }
    
}
