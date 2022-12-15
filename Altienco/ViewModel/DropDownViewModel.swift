//
//  DropDownViewModel.swift
//  Altienco
//
//  Created by Ashish on 04/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

class DropDownViewModel {
    
    var dropDownList : Box<[DropDownResponseObj]> = Box([])
    func getDropDown(model : DropDownRequestModel) {
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.dropDown
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            var dropDownData = [DropDownResponseObj]()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        dropDownData.append(DropDownResponseObj.init(json: dict as! [String : Any]))
                        }
                    self.dropDownList.value.append(contentsOf: dropDownData)
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                }
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }

        }) { (Error) in
            if let error = Error{
                Helper.showToast(error , delay:Helper.DELAY_LONG)
            }
        }
    }
}

