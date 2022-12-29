//
//  AllNotificationViewModel.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class AllNotificationViewModel {
    func getNotification(model : AllNotificationRequest,
                         complition : @escaping([AllNotificationResponce]?, Bool?) -> Void)->Void{
        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.customerNotifications
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            SVProgressHUD.dismiss()
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var notification = [AllNotificationResponce]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        notification.append(AllNotificationResponce.init(json: dict as! [String : Any]))
                        }
                    complition(notification, true)
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String),isAlertView: true)
                    complition(nil, false)
                }
            }

                else{
                    complition(nil, false)
                }
        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error.debugDescription,isAlertView: true)
                complition(nil, false)
            }
            
        }
    }
}


class NewNotificationViewModel {
    func getNewNotification(model : AllNotificationRequest,
                            complition : @escaping([NewNotificationResponse]?, Bool?) -> Void)->Void {
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.checkNewNotification
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var notification = [NewNotificationResponse]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        notification.append(NewNotificationResponse.init(json: dict as! [String : Any]))
                        }
                    complition(notification, true)
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String),isAlertView: true)
                    complition(nil, false)
                }
            }

//                else{
//                    Helper.showToast((jsondata?["Message_Code"] as? String)!, delay:Helper.DELAY_LONG)
//                }
        }) { (Error) in
            if let error = Error{
                Helper.showToast(error, isAlertView: true)
            }
            complition(nil, false)
        }
    }
}
