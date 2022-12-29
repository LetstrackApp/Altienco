//
//  DownloadRecieptApi.swift
//  Altienco
//
//  Created by mac on 22/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SVProgressHUD
class DownloadRecieptApi {
   
    var invoiceLink : String?
    var orderId : String?
    func receiptDownload(userId:Int,
                         orderId:String?,
                         voicherId:Int,
                         serviceTypeId:Int,
                         completion:@escaping(String?)->Void) {
        SVProgressHUD.show(withStatus: "Downloading...")
        if let invoiceLink = invoiceLink {
            
            if let _ = URL(string: invoiceLink) {
                self.btnTapped()
            }
            return
        }
        
        let dict:[String : Any] = ["userId":userId,
                                   "orderId":orderId ?? "",
                                   "voicherId":voicherId,
                                   "serviceTypeId":serviceTypeId]
        let strURl = subURL.downloadInvoice
        let header : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.getToken)",
            "Content-Type":"application/json"]
        AFWrapper.requestPOSTURL(strURl, isDownloadInvoice: true,
                                 params: dict,
                                 headers: header,
                                 success: { (jsondata) in
            debugPrint("jsondata:", strURl, jsondata as Any)
            
            if jsondata?["message_Code"] as? Int == 1,
               let result = jsondata?["result"] as? [String : Any],
               let data = (result["data"] as? NSArray)?.firstObject as? [String : Any],
               let invoiceLink = data["invoiceLink"]  as? String{
                SVProgressHUD.show(withStatus: "Preparing...")

                self.invoiceLink = invoiceLink
                self.orderId = orderId
                if let _ = URL(string: invoiceLink) {
                    self.btnTapped()
                    completion(invoiceLink)
                }else {
                    completion(nil)
                }
                
                
            }
            else{
                Helper.showToast((jsondata?["message"] as? String) ?? lngConst.supportMsg,isAlertView: true)
                completion(nil)
                SVProgressHUD.dismiss()
            }
            
        }) { (Error) in
            SVProgressHUD.dismiss()
            if let error = Error{
                Helper.showToast(error.debugDescription  ,isAlertView: true)
            }
            completion(nil)
        }
        
        
    }
    
    
    
    
    
    
    func btnTapped() {
        if  let pdfurl  = self.invoiceLink {
            self.savePdf(urlString:pdfurl, fileName:"Receipt-\(orderId ?? "")")
        }else {
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "Altienco-\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                SVProgressHUD.dismiss()
                self.sharePdf(path: actualPath)
                //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
            } catch {
                SVProgressHUD.dismiss()
                print("Pdf could not be saved")
            }
        }
    }
    
    
    func sharePdf(path:URL) {
        
        if let controller = UIApplication.topViewController() {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path.path) {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = controller.view
                controller.present(activityViewController, animated: true, completion: nil)
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool,
                                                                       returnedItems:[Any]?, error: Error?) in
                    if completed {
                        if FileManager.default.fileExists(atPath: path.path) {
                            try? FileManager.default.removeItem(at: path)
                        }
                    }
                }
            } else {
                
                
                AltienoAlert.initialization().showAlert(with: .other("document was not found")) { index, _ in

                }
                
            }
        }
    }
    

}





/*
 
 New api Url: https://testnode.altienco.com/api/confirmingIntrPINBankVoucher

 Request: {"langCode":"en","currency":"£","dinominationValue":"15","customerId":"2","operatorId":"3","planName":"P2122", "transactionTypeId" : 2 }
 
 https://testnode.altienco.com/api/verifyCallbackStatus

 Request:
 {
     "externalId": "733552889139388500",
     "apiId": "2237656746",
     "con*/
