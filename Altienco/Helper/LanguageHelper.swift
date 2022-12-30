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
    
    let empytMobile = "Mobile number\ncan not be empty"
    let notValidMobile = "Please enter a valid\nmobile number"
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
    let pleaseSelectAmount = "Please select Amount"
    
    let amount = "Amount"
    let denomination = "denomination"
    let callingCard = "calling card"
    let supportMsg = "Something went wrong Please try again! If problem persists, please contact our support team"
    let addAnotherCard = "ADD ANOTHER CARD"
    let home = "GO TO HOME"
    let topUpPlans = "Top-up Plans"
    let plans = "Plans"
    let generate_voucher = "Generate voucher"
    let voucher = "voucher"
    let add_Balance = "ADD BALANCE"
    let orderNo = "Order No "
    let sendMsg = "SEND MESSAGE"
    let reasonDescription =  "Reason Description"
    let orderIdques =  "Do you have an order ID? "
    let name = "Name"
    let enterName = "Please enter name "
    let emptyEmail = "Enter your Email ID"
    let validEmail = "Enter your a valid Email ID"
    let addAttachments =  "Add Attachments"
    func txnSucessMeg(amount:String) -> String {
        return "You've added \(amount) successfully in your altienco wallet"
    }
    let try_Again =  "Try Again"
    let reasonerror =  "Please select reason"
    let available = "Available"
    let reason =  "Reason"
    let reasonDes = "Please be really specific, so we can help you the best we can."
    let reasonTitle  = "Send us a message"
    let orderidHint = "This is the 9-digit code which can\nbe found in the subject of your\nconfirmation email"
    let  logoutSuccessfully  = "Logout Successfully"
    let shareMsgOncontactUS = """
Thank you for getting in touch!
    
We appreciate you contacting us. One of our colleagues will get back in touch within 48 hours. We are open Mon to Fri 9.30 am to 5.30 pm.

Have a great day!
"""
    let profileUpdate =  "Great. Profile now updated."
    let continue_withCard = "CONTINUE WITH CARD"
    let my_Order = "My Order"
    let order = "Order"
    let my_Transaction = "My Transaction"
    let transaction = "Transaction"
    let voucher_History = "Voucher History"
    let History = "History"
    let reOrder = "Re-Order"
    let voucher_Code_Copied = "Voucher Code Copied Successfully"
    let claim_Code_Copied = "Claim Code Copied Successfully"
    let tryAfterSomeTime = "Please try after Sometime!"
    let allNotification = "All Notification"
    let notification = "Notification"
    let voucher_Generating = "Generating Voucher"
    let deleteAcDes = "If you delete your account permanently, you will not able to get retrive current balance in the app. Do you still want to proceed?"
    let logoutDes = "Security Reset. Please log in again"
    let deleteAccount = "Delete Account"
    let logout = "Logout"
    let cancel = "Cancel"


}



