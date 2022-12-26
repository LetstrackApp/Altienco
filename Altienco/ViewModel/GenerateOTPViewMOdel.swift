//
//  GenerateOTPViewMOdel.swift
//  Altienco
//
//  Created by Ashish on 01/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import DropDown
import UIKit
class GenerateOTPViewModel {
    lazy  var dropDown : DropDown = {
        let drop = DropDown()
        drop.direction = .any
        return drop
    }()
    var user : Box<GenerateOTP?>? = Box(nil)
    func generateOTP(model : GenerateOTP,
                     complition : @escaping(Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.generateOTP
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl,
                                 params: json,
                                 headers: header,
                                 success: { (jsondata) in
            if jsondata?["Message_Code"] as? Bool == true,
               let resultData = jsondata?["Result"] as? [String : Any] {
                if resultData["status"] as? Bool == true {
                    if let jsondata = resultData["data"] as! NSDictionary? {
                        if let isExistingUser = jsondata["isExistingUser"] as? Bool {
                            UserDefaults.setExistingUser(data: isExistingUser)
                            complition(isExistingUser)
                        }
                    }
                }
                else {
                    complition(nil)
                    Helper.showToast((resultData["message"] as? String),isAlertView: true)
                }
            }else {
                complition(nil)
            }
            
        }) { (Error) in
            Helper.showToast(Error,isAlertView: true)
            complition(nil)
        }
    }
    
    
    func showDropDown(view : UIView,
                      stringArry:[String],
                      completion:@escaping(Int,String)->Void) {
        dropDown.anchorView = view
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = stringArry
        dropDown.selectionAction = {   (index: Int,
                                        item: String) in
            completion(index,item)
            
        }
        dropDown.width = view.bounds.width
        dropDown.show()
    }
}

