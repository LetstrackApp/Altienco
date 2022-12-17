//
//  Country.swift
//  LMDispatcher
//
//  Created by APPLE on 08/10/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation


enum CountryCode: String {
    
    case IN = "+91"
    case UK = "+44"
    
    var title : String?{
        switch self {
        case .IN:
            return "India"
        case .UK:
            return "United Kingdom"
        }
    }
    var ISOcode : String?{
        switch self {
        case .IN:
            return "IND"
        case .UK:
            return "GBR"
        }
    }
    var ISOcode2 : String?{
        switch self {
        case .IN:
            return "IN"
        case .UK:
            return "GB"
        }
    }
    var countryID : Int?{
        switch self {
        case .IN:
            return 102
        case .UK:
            return 235
        }
    }
    var numberDigit : Int?{
        switch self {
        case .IN:
            return 10
        case .UK:
            return 10
        }
    }
    
    var minNumberDigit : Int{
        switch self {
        case .IN:
            return 10
        case .UK:
            return 9
        }
    }
}

enum TransactionTypeId : Int {
    case WalletRecharge = 1
    case PhoneRecharge = 2
    case ITopup = 3
    case Giftcard = 4
    case CallingCard = 5
}

enum GiftCardProcessStatus : Int {
    case NotInitiated = 0
    case InProgress = 1
    case Completed = 2
    case Cancelled = 3
    var titleMessage : String{
        switch self {
        case .NotInitiated:
            return "Payment initiated…"
        case .InProgress:
            return "We received payment and Gift Card is in process"
        case .Completed:
            return "Gift Card generated successfully"
        case .Cancelled:
            return "Unable to generate Gift Card. Please try again."
        }
    }
}
