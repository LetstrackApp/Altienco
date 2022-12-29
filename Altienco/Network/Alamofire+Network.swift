//
//  GlobalMethod.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AFWrapper: NSObject {
    class func requestGETURL(_ strURL: String, headers : [String : String]?, success:@escaping (Any?) -> Void, failure:@escaping (Error) -> Void) {
        var url = baseURL.baseURl + strURL
        url = url.replacingOccurrences(of: " ", with: "%20")
        //        debugPrint(url)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 40
        manager.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            debugPrint(responseObject)
            if responseObject.result.isSuccess {
                if responseObject.response!.statusCode == 401 {
                    SVProgressHUD.dismiss()
                    Helper.showToast("Oops, something went wrong. Please try again later. ",isAlertView: true)
                    //
                }
                else if responseObject.response!.statusCode == 403{
                    AlertController.alert(title: "You have been logged out", message: "kindly login again", buttons: ["Ok"]) { (action, index) in
                        appDelegate.setupLogout()
                    }
                }
                else if responseObject.response!.statusCode < 300{
                    success(responseObject.result.value)
                }
                
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                Helper.showToast(error.localizedDescription ,isAlertView: true)

                //                Helper.showToast(error.localizedDescription, delay: Helper.DELAY_SHORT)
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String,
                              isDownloadInvoice:Bool = false,
                              params : [String : Any]?,
                              headers : [String : String]?,
                              success:@escaping ([String:Any]?) -> Void,
                              failure:@escaping (String?) -> Void) {
        let url =  isDownloadInvoice == true ? baseURL.baseURldownload + strURL : baseURL.baseURl + strURL
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 40
        manager.request(url,
                        method: .post,
                        parameters: params,
                        encoding: JSONEncoding.default,
                        headers: headers).responseJSON { (responseObject) -> Void in
            debugPrint(url, responseObject)
            if responseObject.result.isSuccess {
                if let data = responseObject.result.value as? [String:Any]{
                    if responseObject.response!.statusCode == 401 {
                        SVProgressHUD.dismiss()
                        Helper.showToast(lngConst.supportMsg, delay: Helper.DELAY_SHORT,isAlertView: true)
                        failure(lngConst.supportMsg)
                    }
                    else if responseObject.response!.statusCode == 403{
                        AlertController.alert(title: "You have been logged out",
                                              message: "kindly login again",
                                              buttons: ["Ok"]) { (action, index) in
                            appDelegate.setupLogout()
                        }
                        failure("You have been logged out. kindly login again")
                    }
                    else if responseObject.response!.statusCode < 401{
                        success(data)
                    }
                    else{
                        if let errorDict = (responseObject.result.value as? NSDictionary)?["Error"] as? NSDictionary, let message = errorDict["Message"] as? String {
                            failure(message)
                        }else {
                            failure(lngConst.supportMsg)
                        }
                        SVProgressHUD.dismiss()
                        
                        //                    Helper.showToast("Please try agian later", delay: Helper.DELAY_SHORT)
                    }
                }else {
                    Helper.showToast(lngConst.supportMsg,isAlertView: true)
                    failure(lngConst.supportMsg)

                }
                
            }
            if responseObject.result.isFailure {
                //                Helper.showToast(responseObject.result.error!.localizedDescription , delay:Helper.DELAY_LONG)
                Helper.showToast(responseObject.result.error?.localizedDescription,isAlertView: true)

                failure(responseObject.result.error?.localizedDescription)
            }
        }
    }
}


extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    //    @discardableResult
    //    func responseWelcome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Welcome>) -> Void) -> Self {
    //        return responseDecodable(queue: queue, completionHandler: completionHandler)
    //    }
}
