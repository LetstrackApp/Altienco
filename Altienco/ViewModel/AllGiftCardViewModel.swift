//
//  AllGiftCardViewModel.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import  SVProgressHUD

class AllGiftCardViewModel {
    
    var searchGiftCard : Box<[GiftCardResponce]> = Box([])
    
    func getGiftCards(countryCode: String, language: String, pageNum: Int, pageSize: Int) {
        SVProgressHUD.show()
        let strURL = subURL.searchGiftcard + "/\(countryCode)/\(pageNum)/\(pageSize)/\(language)"

        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
            SVProgressHUD.dismiss()
            debugPrint(JSONResponse)
            if let data = JSONResponse as? NSDictionary {
                var giftCardList = [GiftCardResponce]()
                if data["Message_Code"] as? Bool == true, let result = data["Result"] as? NSDictionary
                {
                    for dict in result["data"] as? Array ?? []{
                        giftCardList.append(GiftCardResponce.init(json: dict as! [String : Any]))
                    }
                self.searchGiftCard.value = giftCardList
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
