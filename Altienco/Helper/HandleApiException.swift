////
////  HandleApiException.swift
////  Altienco
////
////  Created by Ashish on 17/09/22.
////  Copyright © 2022 Letstrack. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//
//struct Constant_Functions {
//static func checkErrorCode(error : URLError){
//    if let response = error {
//        if response.errorCode == 401 {
//            //APPDELEGATE.logout()
//            appDelegate.setupLogout()
//            DispatchQueue.main.async {
//                Helper.showToast("Session Expired")
//            }
//        }else {
//            DispatchQueue.main.async {
//                DispatchQueue.main.async {
//                    Helper.showToast("Please try again later!")
//            }
//        }
//    }
//}
//
//static func logoutWithSessionEnd(){
//    
//    
//    AlertController.alert(title: kSessionExpired, message: kPleaseLoginAgain, buttons: [kOk]) { (action, index) in
//        //APPDELEGATE.logout()
//        appDelegate.setupLogout()
//    }
//}
//
//static func checkInternetConnection() -> Bool{
//    if APPDELEGATE.isReachable {
//        return true
//    } else {
//        DispatchQueue.main.async {
//            NotificationBannerHelper.showbanner(title: nil, subtitle: NO_INTERNET_CONNECTION, style: .danger)
//        }
//        return false
//    }
//}
//
//
//}
//}
