//
//  ImageUpload.swift
//  LMDispatcher
//
//  Created by APPLE on 01/10/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import Alamofire

    func requestWith(url: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Bool?, String?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        debugPrint(parameters)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                
                
                if key == "file" || key == "PodFile" || key == "SignatureFile"{
                    if let data = imageData{
                        multipartFormData.append(data, withName: key, fileName: "image.png", mimeType: "image/png")
                    }
                }
                
                else{
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)

                }
            }
        }, usingThreshold: UInt64.init(), to: URL(string: url)!, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response.result.value as Any)
                    let json : [String : Any]? = response.result.value as? Dictionary
                    if json?["Message_Code"] as? Bool == true, let resultData = json?["Result"] as? NSDictionary
                    {
                        var url = ""
                        if resultData["status"] as? Bool == true{
                            if let data = resultData["data"] as? NSDictionary{
                                url = data["image_Url"] as? String ?? ""
                            }
                            onCompletion?(true, url)
                    }
                    else
                    {
                        Helper.showToast((resultData["message"] as? String)!, delay:Helper.DELAY_LONG)
                        onCompletion?(false, "")
                    }
                    if let err = response.error{
                        onError?(err.localizedDescription as? Error)
                        onCompletion?(false, "")
                        return
                    }}}
            case .failure(let error):
                debugPrint("Error in upload: \(error.localizedDescription)")
                onError?(error)
                onCompletion?(nil, "")
            }
        }
    }

