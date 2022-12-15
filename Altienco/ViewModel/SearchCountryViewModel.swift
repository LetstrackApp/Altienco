//
//  SearchCountryViewModel.swift
//  Altienco
//
//  Created by Ashish on 29/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class SearchCountryViewModel {
    
    var searchCountry : Box<[SearchCountryModel]> = Box([])
    
    func getCountryList() {
        let strURL = subURL.searchCountry
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestGETURL(strURL, headers: header, success: {
            (JSONResponse) -> Void in
            debugPrint(JSONResponse)
            if let data = JSONResponse as? NSDictionary {
                var countryList = [SearchCountryModel]()
                if data["Message_Code"] as? Bool == true, let result = data["Result"] as? NSDictionary
                {
                    for dict in result["data"] as? Array ?? []{
                        countryList.append(SearchCountryModel.init(json: dict as! [String : Any]))
                    }
                self.searchCountry.value = countryList
                    }
                else{
//                    Helper.showToast((data["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }
        }) {
            (error) -> Void in
            debugPrint(error.localizedDescription)
        }
    }
}
