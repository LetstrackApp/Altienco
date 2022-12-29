//
//  FixedCardViewModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class FixedCardViewModel {
    
    var searchFixedGiftCard : Box<[FixedGiftResponseObj]> = Box([])
    
    func getFixedGiftCards(countryCode: String, language: String, planType: Int, operatorID: Int,completion:@escaping(Bool)->Void) {
        let strURL = subURL.searchCardPlans + "/\(countryCode)/\(operatorID)/\(planType)/\(language)"
//        SVProgressHUD.show()
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
//            debugPrint(JSONResponse)
            SVProgressHUD.dismiss()
            completion(true)
            if let data = JSONResponse as? NSDictionary {
                var giftCardList = [FixedGiftResponseObj]()
                if data["Message_Code"] as? Bool == true, let result = data["Result"] as? NSDictionary
                {
                    for dict in result["data"] as? Array ?? []{
                        giftCardList.append(FixedGiftResponseObj.init(json: dict as! [String : Any]))
                    }
                self.searchFixedGiftCard.value = giftCardList
                    }
                else{
//                    Helper.showToast((data["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }
        }) {
            (error) -> Void in
            completion(false)
            debugPrint(error.localizedDescription)
        }
    }
}


