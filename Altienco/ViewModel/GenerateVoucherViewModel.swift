//
//  GenerateVoucherViewModel.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class GenerateVoucherViewModel {
    
//    var voucher : Box<GenerateVoucherResponseObj> = Box(GenerateVoucherResponseObj())
    
    func generateVoucher(model : GenerateVoucherModel,
                         complition : @escaping(GenerateVoucherResponseObj?,
                                                Bool?, String?) -> Void)->Void{
        //        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.generateVoucher
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl,
                                 params: json,
                                 headers: header,
                                 success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            SVProgressHUD.dismiss()
            if jsondata?["Message_Code"] as? Bool == true,
               let resultData = jsondata?["Result"] as? NSDictionary{
                let msg = resultData["message"] as? String ?? lngConst.supportMsg

                if resultData["status"] as? Bool == true{
                    if let jsondata = resultData["data"] as! NSDictionary?,jsondata.count > 0 {
                        let model = GenerateVoucherResponseObj.init(json: jsondata as! [String : Any])
                        complition(model, true, "")
                        return
                    }else {
                        complition(nil, false, msg)
                        return
                    }
                }
                else
                {
                    complition(nil, false, msg)
                    return
                }
            }else {
                complition(nil, false, lngConst.supportMsg)
                return
            }
            
            
        }) { (Error) in
            SVProgressHUD.dismiss()
            Helper.showToast(Error?.debugDescription ,isAlertView: true)
            complition(nil, false, Error?.description)
        }
    }
    
    
    
    func confirmingIntrPINBankVoucher(model : GenerateVoucherModel,
                         complition : @escaping(ConfirmingIntrPINBankVoucherModel?,
                                                Bool?, String?) -> Void)->Void{
        //        SVProgressHUD.show()
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.confirmingIntrPINBankVoucher
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type": "application/json"
        ]
        AFWrapper.requestPOSTURL(strURl,
                                 params: json,
                                 headers: header,
                                 success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            SVProgressHUD.dismiss()
            if jsondata?["Message_Code"] as? Bool == true,
               let resultData = jsondata?["Result"] as? NSDictionary {
                let msg = resultData["message"] as? String
                if resultData["status"] as? Bool == true{
                    if let jsondata = resultData["data"] as! NSDictionary?,jsondata.count > 0 {
                        let model = ConfirmingIntrPINBankVoucherModel.init(json: jsondata as! [String : Any])
                        
                        complition(model, true, "")
                        return
                    }else {
                        complition(nil, false, msg)
                        return
                    }
                }
                else
                {
                   
                    complition(nil, false, msg)
                    return
                }
            }else {
                complition(nil, false, lngConst.supportMsg)
                return
            }
            
            
        }) { (Error) in
            SVProgressHUD.dismiss()
            Helper.showToast(Error?.debugDescription ,isAlertView: true)
            complition(nil, false, Error?.description)
        }
    }
    
}
