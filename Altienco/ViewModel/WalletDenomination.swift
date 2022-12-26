//
//  WalletDenomination.swift
//  Altienco
//
//  Created by Deepak on 22/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class WalletDenomination {
    
    func getDenomination(model : WalletDenominationRequest, complition : @escaping([WalletDenominationResponse]?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.getDenomination
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var denominationData = [WalletDenominationResponse]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        denominationData.append(WalletDenominationResponse.init(json: dict as! [String : Any]))
                        }
                    complition(denominationData, true)
                }
                else
                {
                    Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                    complition(nil, false)
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
            complition(nil, false)
        }
    }
}

class OnlinePaymentIntent {
    func getPaymentIntent(model : PaymentIntentRequest, complition : @escaping([PaymentIntentResponse]?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.getPaymentIntent
        SVProgressHUD.show()
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            SVProgressHUD.dismiss()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var paymentIntent = [PaymentIntentResponse]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        paymentIntent.append(PaymentIntentResponse.init(json: dict as! [String : Any]))
                        }
                    complition(paymentIntent, true)
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
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error , isAlertView: true)
            }
            complition(nil, false)
        }
    }
}


class VerifyPaymentViewModel {
    
    func verifyPayment(model : VerifyPaymentRequest,
                       complition : @escaping([VerifyPaymentResponse]?, Bool?) -> Void)->Void{
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.verifyPayment
//        SVProgressHUD.show()
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
//            SVProgressHUD.dismiss()
            if jsondata?["Message_Code"] as? Bool == true, let resultData = jsondata?["Result"] as? NSDictionary
            {
                var payment = [VerifyPaymentResponse]()
                if resultData["status"] as? Bool == true{
                    for dict in resultData["data"] as? Array ?? []{
                        payment.append(VerifyPaymentResponse.init(json: dict as! [String : Any]))
                        }
                    complition(payment, true)
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
                Helper.showToast(error , isAlertView: true)
            }
            SVProgressHUD.dismiss()
            complition(nil, false)
        }
    }
}
