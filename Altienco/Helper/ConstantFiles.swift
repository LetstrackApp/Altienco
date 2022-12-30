//
//  ConstantFiles.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation
import UIKit


enum baseURL {
    //        static let baseURl = "https://testnode.altienco.com/api/"
    //        static let baseURldownload = "https://dadmin.altienco.com/api/"
    static let baseURldownload = "https://admin.altienco.com/api/"
    static let baseURl = "https://node.altienco.com/api/"
    static let imageBaseURl = "http://testnode.eu-west-2.elasticbeanstalk.com/"
    static let termsCondition = "https://www.altienco.com/TermsAndConditions.html"
    static let helpAndSupport =  "https://www.altienco.com/help.html"
    //"https://www.altienco.com/TermsAndConditions.html"
    static let imageURL = "http://dadmin.altienco.com/Profile/Image"
}

enum subURL{
    static let confirmingIntrPINBankVoucher = "confirmingIntrPINBankVoucher"
    
    static let generateOTP = "generateOTP"
    static let verifyOTP = "verifyOTP"
    static let resendOTP = "resendOTP"
    static let registration = "registration"
    static let verifyPin = "verifyPIN"
    static let addMoney = "addMoney"
    static let getOperator = "getOperator"
    static let getOperatorPlans = "getOperatorPlans"
    static let generateVoucher = "generatePINBankVoucher"
    static let history = "getOrderHistory"
    static let transactionHistory = "getTransactionHistory"
    static let voucherHistory = "getVoucherHistory"
    static let dropDown = "getDropdownItems"
    static let usedMark = "markPINBankAsUsed"
    static let advertisment = "advertisment"
    static let searchCountry = "tpCountries"
    static let intrOperator = "searchIntrOperator"
    static let intrOperatorPlans = "getIntrOperatorPlans"
    static let intrConfirmRecharge = "confirmingIntrRecharge"
    static let uploadImage = "uploadImage"
    static let searchGiftcard = "searchGiftcardOperators"
    static let searchCardPlans = "searchGiftcardOperatorPlans"
    static let confirmingGiftCard = "confirmingGiftCard"
    static let getDenomination = "getWalletDenomination"
    static let getPaymentIntent = "getPaymentIntent"
    static let verifyPayment = "verifyPayment"
    static let verifyCallbackStatus = "verifyCallbackStatus"
    static let customerNotifications = "getCustomerNotifications"
    
    static let checkNewNotification = "checkAnyNewNotification"
    static let deactivateAccount = "deactivateAccount"
    
    
    
    static let languageList = "LanguageList/0"
    static let verifyToken = "verifyToken"
    static let getHelpNSupportReasons = "getHelpNSupportReasons"
    static let submitHelpNSupportRequest = "submitHelpNSupportRequest"
    static let uploadAttachment = "uploadAttachment"
    static let downloadInvoice = "downloadInvoice"
}

enum appColor{
    static let viewBackColor = UIColor(red: 0/255, green: 165/255, blue: 205/255, alpha: 1)
    static let buttonGreenColor = UIColor(red: 35/255, green: 206/255, blue: 107/255, alpha: 1)
    static let buttonRedColor = UIColor(red: 235/255, green: 68/255, blue: 68/255, alpha: 1)
    static let blueColor = UIColor(red: 9/255, green: 100/255, blue: 232/255, alpha: 1)
    static let purpleColor = UIColor(red: 176/255, green: 73/255, blue: 147/255, alpha: 1)
    
    static let lightGrayBack = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    static let otpBorderColor = UIColor(red: 225/255, green: 245/255, blue: 252/255, alpha: 1)
    static let blackText = UIColor(red: 43/255, green: 42/255, blue: 41/255, alpha: 1)
    static let lightGrayText = UIColor(red: 120/255, green: 123/255, blue: 128/255, alpha: 1)
    static let buttonBackColor = UIColor(red: 2/255, green: 42/255, blue: 114/255, alpha: 1)
    static let highlightTextColor = UIColor(red: 176/255, green: 73/255, blue: 147/255, alpha: 1)
    
    
}
