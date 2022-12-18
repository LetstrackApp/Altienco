//
//  LanguageHelper.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Localize_Swift

struct langguageConstent{
    let agreetext = "agree".localized()
    let termsText = "terms".localized()
    let Step3 = "Step3".localized()
    let Step4 = "Step4".localized()
    
    let chooseLanguage = "CHOOSE YOUR PREFERRED LANGUAGE".localized()
    let langTitle = "langTitle".localized()
    let next = "next".localized()
    let proceed = "PROCEED".localized()
    let addBalance = "addBalance".localized()
    let register = "register".localized()
    let add = "ADD".localized()
    let countrySCTitle = "countrySCTitle".localized()
    let mobile = "mobile".localized()
    let otptitle = "otptitle".localized()
    let optAlertMsg = "optAlertMsg".localized()
    let resend = "resend".localized()
    let resendOTP = "resendOTP".localized()
    
    let storeTitle = "storeTitle".localized()
    let addressTitle = "addressTitle".localized()
    let stateTitle = "stateTitle".localized()
    let cityTitle = "cityTitle".localized()
    let optionalTitle = "optionalTitle".localized()
    let signupTitle = "signupTitle".localized()
    let gstTtile = "gstTtile".localized()
    let panTitle = "panTitle".localized()
    let tinTitle = "tinTitle".localized()
    
    let USignupTitle = "USignupTitle".localized()
    let firstName = "firstName".localized()
    let lastName = "lastName".localized()
    let email = "email".localized()
    let password = "password".localized()
    let gender = "gender".localized()
    let inviteCode = "inviteCode".localized()
    let privacy = "privacy".localized()
    let conditionText = "conditionText".localized()
    // signupWelcome
    let welcomeTitle = "welcomeTitle".localized()
    let welcomeSubTitle = "welcomeSubTitle".localized()
    let welcomeLastSubTitle = "welcomeLastSubTitle".localized()
    let startListing = "startListing".localized()
    let signup = "signup".localized()
    let changePhoto = "changePhoto".localized()
    // UserProfile
    let welocme = "welocme".localized()
    let userSubTitle = "userSubTitle".localized()
    let userStep1 = "userStep1".localized()
    let verifyAadhaar = "verifyAadhaar".localized()
    let addRider = "addRider".localized()
    let verifyDL = "Verify Driver’s Licence*".localized()
    let addVehichle = "addVehichle".localized()
    let laterButton = "laterButton".localized()
    let startOrder = "startOrder".localized()
    //AddRider
    let riderPicTtile = "riderPicTtile".localized()
    let verifyLicence = "verifyLicence".localized()
    let addThisRider = "addThisRider".localized()
    let startTakingOrders = "startTakingOrders".localized()
    //VerifyAadhaar
    let AadhaarCrad = "AadhaarCrad".localized()
    let verify = "verify".localized()
    //VerifyNumber
    let riderNumbertitle = "riderNumbertitle".localized()
    let close = "close".localized()
    let ok = "ok".localized()
    let changeOrder = "changeOrder".localized()
    
    let warning = "warning".localized()
    let notification_access = "notification_access".localized()
    let signatureTitle = "signTitle".localized()
    let receiverName = "receiverName".localized()
    let selectCountery = " Please select country first "

    let empytMobile = " Mobile number \n can not be empty "
    let notValidMobile = " Please enter a valid \n mobile number "
    let verificationHint = "We may send a verification code to this number"
    let phoneNumber =  "Phone Number"
    
    let whatYouGetDes = """
You will get freedom to recharge phone, buy
calling cards, pay utility bills, book movies/tickets,
or avail various services from other partner
applications.
"""
    let step2Des = """
Enter the 16 Digit Pin and Verify
"""
    let step1Des =  """
Scratch the altienco card to get
the 16 digit pin
"""
 let addMoneyToAltiencocard =   "Add money from altienco card"
    
    let altiencoCard  = "altienco card"
    
    let step1 = "\u{2022} Step 1"
    let step2 = "\u{2022} Step 2"
    let what_you_get = "What you get"
    let wlecomeAddBalance = "Welcome, let's add some balance"
    let add_newBalance_now = "+ADD BALANCE NOW"
    let generatecCllingCard = "Generate calling card"
    let international_top_up = "International top-up"
    let top_up = "top-up"
    let pleaseSelectDenomination = "Please select denomination"
    let rechargeWallet = "Recharge wallet"
    let wallet = "wallet"
    let denomination = "denomination"
    let callingCard = "calling card"
    let supportMsg = "Something went wrong Please try again! If problem persists, please contact our support team"
    let addAnotherCard = "ADD ANOTHER CARD"

    func txnSucessMeg(amount:String) -> String {
        return "You've added \(amount) successfully in your altienco wallet"
    }
    
}



