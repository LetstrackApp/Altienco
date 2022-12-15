//
//  RangeCardViewModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class RangeCardViewModel {
    
    var searchRangeGiftCard : Box<[RangeGiftCardResponse]> = Box([])
    
    func getRangeGiftCards(countryCode: String, language: String, planType: Int, operatorID: Int) {
        SVProgressHUD.show()
        let strURL = subURL.searchCardPlans + "/\(countryCode)/\(operatorID)/\(planType)/\(language)"

        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
            SVProgressHUD.dismiss()
            debugPrint(JSONResponse)
            if let data = JSONResponse as? NSDictionary {
                var giftCardList = [RangeGiftCardResponse]()
                if data["Message_Code"] as? Bool == true, let result = data["Result"] as? NSDictionary
                {
                    if let data = result["data"] as? NSArray{
                    do {
                            if let theJSONData = try?  JSONSerialization.data(withJSONObject: data,options: .prettyPrinted) {
                                let detail = try JSONDecoder().decode([RangeGiftCardResponse].self, from: theJSONData)
                                giftCardList.append(contentsOf: detail)
                                debugPrint("", detail.first?.destinationAmount?.min)
                                self.searchRangeGiftCard.value = giftCardList
                            }
                        }
                        catch (let e) {
//                            failure(e.localizedDescription)
                            debugPrint(e)
                        }
                    }
                
                    }
                else{
//                    Helper.showToast((data["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }
        }) {
            (error) -> Void in
            SVProgressHUD.dismiss()
            debugPrint(error.localizedDescription)
        }
    }
}

