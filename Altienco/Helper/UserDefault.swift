//
//  UserDefault.swift
//  LMDispatcher
//
//  Created by APPLE on 15/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        //Constants
        static let isAvtarImage = "isAvtarImage"
        static let isExistingUser = "isExistingUser"
        static let isnotifyRead = "isnotifyRead"
        static let userID = "userid"
        static let mobileNumber = "phone"
        static let userToken = "myToken"
        static let mobileCode = "mobileCode"
        static let countryCode = "countryCode"
        static let stateCode = "stateCode"
        static let userModel = "getUser"
    }
    
    class var getUserData:  UserModel?   {
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaults.Keys.userModel) as? Data {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(UserModel.self, from: savedPerson)
            }
            catch{
                return nil
            }
            
        }
        return nil
    }
    
    class func setUserData(data: UserModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaults.Keys.userModel)
        }
    }
    
    class var getAvtarImage: String  {
       UserDefaults.standard.string(forKey: UserDefaults.Keys.isAvtarImage) ?? "false"
        
    }
    class func setAvtarImage(data: Bool) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.isAvtarImage)
    }
    
    class var isNotificationRead: String  {
       UserDefaults.standard.string(forKey: UserDefaults.Keys.isnotifyRead) ?? "false"
        
    }
    class func setNotificationRead(data: Bool) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.isnotifyRead)
    }
    
    class var getExistingUser: String  {
       UserDefaults.standard.string(forKey: UserDefaults.Keys.isExistingUser) ?? "false"
        
    }
    class func setExistingUser(data: Bool) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.isExistingUser)
    }
    
    class var getUserID: Int  {
        let storedValue = UserDefaults.standard.integer(forKey: UserDefaults.Keys.userID) 
        return storedValue
    }
    class func setUserID(data: Int) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.userID)
    }

    
    class var getMobileNumber: String  {
        let storedValue = UserDefaults.standard.string(forKey: UserDefaults.Keys.mobileNumber) ?? ""
        return storedValue
    }
    class func setMobileNumber(data: String) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.mobileNumber)
    }
    
    class var getToken: String  {
        UserDefaults.standard.string(forKey: UserDefaults.Keys.userToken) ?? ""
    }
    
    class func setToken(data: String) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.userToken)
    }
    
    class var getMobileCode: String  {
        UserDefaults.standard.string(forKey: UserDefaults.Keys.mobileCode) ?? ""
    }
    
    class func setMobileCode(data: String) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.mobileCode)
    }
    
    
    class var getCountryCode: String  {
        UserDefaults.standard.string(forKey: UserDefaults.Keys.countryCode) ?? ""
    }
    
    class func setCountryCode(data: String) {
        UserDefaults.standard.set(data, forKey: UserDefaults.Keys.countryCode)
    }
    
    
    
}
