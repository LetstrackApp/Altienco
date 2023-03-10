//
//  ContactUSViewModel.swift
//  Altienco
//
//  Created by mac on 21/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
protocol ResionAPi {
    var infoSelected: Bool { get set }
    var name: String? { get set }
    var email: String? { get set }
    var mobile: String? { get set }
    var reasonID: Int { get set }
    var reasonDes: String? { get set }
    var orderID: String? { get set }
    var attachmentURL: String? { get set }
    var reasonModel: [ReasonModel] {get set }
    
    func getReasonList(completion:@escaping(Bool)->Void)
    func validateFileds(textfiled:[UITextField])->UserValidationState
    func sunbmitDataToserver(completion:@escaping(Bool)->Void)
    func imageUplaod(image:UIImage,completion:@escaping(Bool?)->Void)
    
    
}



class ReasionViewModel {
    var infoSelected = false
    var name: String?
    var email: String?
    var mobile: String?
    var reasonID: Int = 0
    var reasonDes: String?
    var orderID: String?
    var attachmentURL: String?
    var reasonModel: [ReasonModel] = []
    init (){
        
    }
}


extension ReasionViewModel: ResionAPi {
    
    
    func imageUplaod(image:UIImage,
                     completion:@escaping(Bool?)->Void)  {
        
        let data = image.jpegData(compressionQuality: 0.4)
        let parameters: [String : Any] = ["file": data!,
                                          "id": UserDefaults.getUserData?.customerID ?? 0]
        let url = baseURL.baseURl + subURL.uploadAttachment
        requestWith(url: url,
                    imageData: data!,
                    parameters: parameters) { result, url in
            if result == true {
                self.attachmentURL = url
                
            }
            completion(result)
        }
        

    }
    
    func sunbmitDataToserver(completion:@escaping(Bool)->Void) {
        
        let model =  ResasonSubmit.init(userId: UserDefaults.getUserID,
                                        requesterName: name,
                                        requesterEmail: email,
                                        requesterMobile: mobile,
                                        requesterReasonId: reasonID,
                                        requesterRemarks: reasonDes,
                                        attachmentPath: attachmentURL,
                                        orderId:orderID)
        
        let data = try? JSONEncoder().encode(model)
        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        let strURl = subURL.submitHelpNSupportRequest
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl, params: json, headers: header, success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            //,let data = jsondata?["data"] as? [String : Any]
            if jsondata?["Message_Code"] as? Int == 1 {
               // Helper.showToast(lngConst.shareMsgOncontactUS, delay:Helper.DELAY_LONG)
                completion(true)
            }
            else{
                Helper.showToast((jsondata?["Message"] as? String) , isAlertView: true)
                completion(false)
            }
            
        }) { (Error) in
            if let error = Error{
                Helper.showToast(error.debugDescription , isAlertView: true)
            }
            completion((false))
        }
    }
    
    /*
     : https://testnode.altienco.com/api/submitHelpNSupportRequest
     Request:
     {
     "userId": 0,
     "requesterName":"string",
     "requesterEmail": "string",
     "requesterMobile":"string",
     "requesterReasonId": 0,
     "requesterRemarks":"string",
     "attachmentPath":"string"
     }*/
    
    func validateFileds(textfiled:[UITextField])-> UserValidationState {
         if name == nil || name?.isEmpty == true {
             textfiled.first?.setError(lngConst.enterName, show: true, constent: -20, showImage: true)
             
            return .Invalid(lngConst.enterName)
        }
        if email == nil || email?.isEmpty == true {
            textfiled[1].setError(lngConst.emptyEmail, show: true, constent: -20, showImage: true)

            return .Invalid(lngConst.emptyEmail)
        }
        if Validator.isValidEmail(email ?? "") == false {
            textfiled[1].setError(lngConst.validEmail, show: true, constent: -20, showImage: true)
            return .Invalid(lngConst.validEmail)
        }
        if mobile == nil || mobile?.isEmpty == true {
            textfiled[2].setError(lngConst.empytMobile, show: true, constent: -20, showImage: true)

            return .Invalid(lngConst.empytMobile)
        }
        if mobile?.count ?? 0 < 10 {
            textfiled[2].setError(lngConst.notValidMobile, show: true, constent: -11, showImage: true)

            return .Invalid(lngConst.notValidMobile)
        }
        
        if mobile?.count ?? 0 < 10 {
            textfiled[2].setError(lngConst.notValidMobile, show: true, constent: -11, showImage: true)

            return .Invalid(lngConst.notValidMobile)
        }
        if reasonID == 0 {
            textfiled[3].setError(lngConst.reasonerror, show: true, constent: -11, showImage: false)

            return .Invalid(lngConst.reasonerror)
        }
        return .Valid
        //empytMobile
    }
    
    func getReasonList(completion:@escaping(Bool)->Void) {
        
        let header : HTTPHeaders = ["Content-Type":"application/json"]
        AFWrapper.requestGETURL(subURL.getHelpNSupportReasons,
                                headers: header) { result in
            if let data = result as? NSDictionary {
                if data["Message_Code"] as? Bool == true,
                   let resultData = data["Result"] as? NSDictionary,
                   let data = resultData["data"] as? [[String:Any]]
                {
                    self.reasonModel = []
                    for list in data {
                        self.reasonModel.append(ReasonModel.init(json: list))
                    }
                    
                    completion(true)
                    return
                }
                else{
                    if let message = data["message"] as? String{
                        Helper.showToast(message ,isAlertView: true)
                        
                    }
                    completion(false)
                    
                }
            }else{
                Helper.showToast(lngConst.supportMsg, isAlertView: true)
                completion(false)
            }
        } failure: { error in
            Helper.showToast(error.localizedDescription, isAlertView: true)
            completion(false)
        }
    }
    
    
}
