//
//  AppDelegate.swift
//  LMDispatcher
//
//  Created by APPLE on 09/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Alamofire
//import Firebase
import UserNotifications
import LocalAuthentication
import Stripe

let appDelegate = UIApplication.shared.delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navController: UINavigationController?
    var verifyModel = VerifyTokenViewModel()
    var isFaceDetect = false
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        window!.overrideUserInterfaceStyle = .light
        return self.orientationLock
    }
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.handleAuthentication()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0"
        UNUserNotificationCenter.current().delegate = self
        self.registerPushNotification( application)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.tintColor = .black
        IQKeyboardManager.shared.enable = true
//                        self.fontDelegate()
        navController = UINavigationController()
        self.setupNavigationBarAppearance()
        self.handleAuthentication()
        
        if UserDefaults.getToken != "" &&
            UserDefaults.getUserData?.firstName != "" &&
            UserDefaults.getUserData?.firstName != nil {
            self.initialPoint(Controller: DashboardVC())
//            let model = VerifyToken.init(token: UserDefaults.getToken,
//                                         mobileNo: "",
//                                         mobileRegID: "",
//                                         mobileMake: "",
//                                         mobileModel: "",
//                                         mobileOSVersion: "",
//                                         mobileOSType: "")
//            verifyModel.checkToken(model: model) { (result) in
//
//                self.initialPoint(Controller: DashboardVC())
//
////                DispatchQueue.main.async { [weak self] in
////                    if  result != nil{
//////                        if result?.isProfileUpdated == false{
//////                            self?.initialPoint(Controller: UserProfileVC())
//////                        }
//////                        else{
//////                            self?.initialPoint(Controller: DashScreenVC())
//////                        }
////                    }
////                    else{
////
////                        self?.initialPoint(Controller: DashboardVC())
////                    }
////                }
//            }
        }
        else{
            self.initialPoint(Controller: CountrySelectionVC())
        }
        return true
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://stripe-redirect")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }

    // This method handles opening universal link URLs (for example, "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
    }
    
    func initialPoint(Controller: UIViewController){
        navController = UINavigationController(rootViewController: Controller)
        self.makeWindowVisible(navController: self.navController)
        
    }
    
    
    func makeWindowVisible( navController : UINavigationController?){
        navController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController?.navigationBar.shadowImage = UIImage()
        navController?.navigationBar.isTranslucent = false
        let yourBackImage = UIImage(named: "ic_back")
        navController?.navigationBar.backIndicatorImage = yourBackImage
        navController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navController?.navigationBar.topItem?.title = ""
        navController?.navigationBar.tintColor = UIColor.black
        self.window?.rootViewController = navController
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            self.window?.makeKeyAndVisible()
        }) { (result) in
            
        }
        
    }
    
    func fontDelegate() {
        for family: String in UIFont.familyNames
        {
                        debugPrint("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                debugPrint("== \(names)")
            }
        }
    }
    func setupNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        let navbarTitleAtt = [
            NSAttributedString.Key.font:UIFont.SF_Bold(18.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().titleTextAttributes = navbarTitleAtt as [NSAttributedString.Key : Any]
        self.navController?.interactivePopGestureRecognizer?.isEnabled = false    
    }
    func setupLogout(){
        
        deleteData()
        DispatchQueue.main.async {
        self.navController?.popToRootViewController(animated: false)
        self.initialPoint(Controller: CountrySelectionVC())
        DispatchQueue.main.async {
            AltienoAlert.initialization().showAlert(with: .logout) { (index, title) in
                
            }
        }
        }
    }
    
    func deleteData(){
        UserDefaults.setUserData(data: UserModel())
        UserDefaults.setUserID(data: 0)
        UserDefaults.setMobileCode(data: "")
        UserDefaults.setExistingUser(data: false)
        UserDefaults.setMobileNumber(data: "")
        UserDefaults.setToken(data: "")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    
}


extension AppDelegate{
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
      ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
      }

    //Called if unable to register for APNS.
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
}

//MARK:- UNUserNotificationCenterDelegate Methods.
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func registerForPushNotifications() {
      //1
      UNUserNotificationCenter.current()
        //2
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
          //3
          print("Permission granted: \(granted)")
        }
    }

    
    func registerPushNotification(_ application: UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//                [weak self] (granted, error) in
//
//                guard granted else {
//                    self?.showPermissionAlert()
//                    return
//                }
//                //self?.configureCustomActions()
//                self?.getNotificationSettings()
//            }
//        } else {
//            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//            UIApplication.shared.registerForRemoteNotifications()
//        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    func showPermissionAlert() {
        if UIApplication.shared.applicationState == .active{
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            let alert = UIAlertController(title: StringConst.warning, message: StringConst.notification_access, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
                self?.gotoAppSettings()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        })
        }
    }
    
    func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          // Print full message.
          print("user informm", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        debugPrint("userinfo", userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    // face detection
    
    func handleAuthentication() {
        
        let authState: AuthenticationState = self.isAuthenticationRequired()
        switch authState {
        case .logOut:
            self.authenticateUser()
        default:
            DispatchQueue.main.async {
//                Helper.showToast(authState.message)
            }
        }
    }
    
    // MARK: - Helper Methods
    func isAuthenticationRequired() -> AuthenticationState {
        
        if AccessControl.isAuthenticationSupported() {
            
            if UserDefaults.standard.bool(forKey: Constants.kUD_Authentication) {
                // App is set up properly
                let selectedAuthTime: AuthTime = AuthTime(rawValue: UserDefaults.standard.integer(forKey: Constants.kUD_Auth_Time)) ?? .immediately
                switch selectedAuthTime {
                case .immediately:
                    return AuthenticationState.logOut
                default:
                    if let lastAuthTime = UserDefaults.standard.object(forKey: Constants.kUD_Auth_LastDateTime) as? Date {
                        if self.getTimeDifference(fromDate: lastAuthTime) > selectedAuthTime.timeInterval {
                            return AuthenticationState.logOut
                        } else {
                            return AuthenticationState.loggedIn
                        }
                    } else {
                        
                        return AuthenticationState.loggedIn
                    }
                }
            } else {
                return AuthenticationState.notEnrolled
            }
        } else {
            return AuthenticationState.notSupported
        }
    }
    
    func getTimeDifference(fromDate date: Date) -> Int {
        let cal = Calendar.current
        let currentDateTime = Date()
        let components = cal.dateComponents([.minute], from: date, to: currentDateTime)
        return components.minute ?? 0
    }
    
    // MARK: - Main Function
    func authenticateUser() {
        
        AccessControl.shared.evalute { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    self.initialPoint(Controller: DashboardVC())
//                    Helper.showToast(AuthenticationState.loggedIn.message)
                }
            } else {
                var errorStr: String?
                if let error = evaluateError {
                    if error.code == LAError.userCancel || error.code == LAError.systemCancel {
                        errorStr = "Time to log out from App."
                    } else {
                        errorStr = AccessControl.shared.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)
                    }
                }
                DispatchQueue.main.async {
                    self.initialPoint(Controller: CountrySelectionVC())
//                    Helper.showToast("Sorry!!... failed not authenticate")
                }
            }
        }
    }
    ///
    
}

//MARK:- reachibility
//extension AppDelegate {
//    func setUpReachibility(){
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                print("Reachable via WiFi")
//                self.isReachable = true
//            } else {
//                print("Reachable via Cellular")
//                self.isReachable = true
//            }
//        }
//        reachability.whenUnreachable = { _ in
//            print("Not reachable")
//            self.isReachable = false
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
//}
