//
//  LeftScreenVC.swift
//  Altienco
//
//  Created by APPLE on 17/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SideMenu

enum LeftMenu: Int {
    case Profile = 0
    case History
    case Helpline
    case Privacy
    case Logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftScreenVC: UIViewController {

    @IBOutlet weak var imageContainer: UIView!{
        didSet{
            imageContainer.layer.cornerRadius = imageContainer.frame.height/2
            imageContainer.clipsToBounds=true
            imageContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            imageContainer.layer.borderWidth = 1.0
        }
    }
    var viewModel: DeleteAccountViewModel?
    var menus = ["My Profile", "My Orders", "Balance & History", "My Vouchers", "Help & Support",
                 "Contact US","Refer a Friend", "Logout"]
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    
    @IBOutlet weak var profileView: UIView!{
        didSet{
            profileView.layer.cornerRadius = 8
            profileView.clipsToBounds=true
            profileView.layer.borderColor = appColor.lightGrayBack.cgColor
            profileView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var firstHeaderView: UIView!{
        didSet{
            firstHeaderView.layer.cornerRadius = 8
            firstHeaderView.clipsToBounds=true
            firstHeaderView.layer.borderColor = appColor.lightGrayBack.cgColor
            firstHeaderView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var secondHeaderView: UIView!{
        didSet{
            secondHeaderView.layer.cornerRadius = 8
            secondHeaderView.clipsToBounds=true
            secondHeaderView.layer.borderColor = appColor.lightGrayBack.cgColor
            secondHeaderView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            self.profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            self.profileImage.contentMode = .scaleAspectFit // OR .scaleAspectFill
            self.profileImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailID: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeleteAccountViewModel()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initializeValue()
        self.updateProfilePic()
    }
    func updateProfilePic(){
        if (UserDefaults.getUserData?.profileImage) != nil
        {
            
            if let aString = UserDefaults.getUserData?.profileImage
            {
                if UserDefaults.getAvtarImage == "1"{
                    self.profileImage.image = UIImage(named: aString)
                }else{
                let newString = aString.replacingOccurrences(of: baseURL.imageURL, with: baseURL.imageBaseURl, options: .literal, range: nil)
                 
                self.profileImage.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "defaultUser"))
                }
            }
        }

    }
    
    func initializeValue()
    {
        if UserDefaults.getUserData?.firstName != ""
        {
            userName.text = (UserDefaults.getUserData?.firstName ?? "" + (UserDefaults.getUserData?.lastName ?? ""))
            phoneNumber.text = "\(UserDefaults.getMobileCode) \(UserDefaults.getMobileNumber)"
            emailID.text = UserDefaults.getUserData?.emailID
        }
        if (UserDefaults.getUserData?.profileImage) != nil
        {
            
            if let aString = UserDefaults.getUserData?.profileImage
            {
                if UserDefaults.getAvtarImage == "1"{
                    self.profileImage.contentMode = .scaleAspectFit
                    self.profileImage.image = UIImage(named: aString)
                }else{
                let newString = aString.replacingOccurrences(of: baseURL.imageURL, with: baseURL.imageBaseURl, options: .literal, range: nil)
                self.profileImage.contentMode = .scaleToFill
                self.profileImage.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "defaultUser"))
                }
            }
        }
    }
   
    
    
    @IBAction func profileButton(_ sender: Any) {
        self.navigationController?.pushViewController(ProfileVC(), animated: true)
    }
    @objc func profileDetails(gestureRecognizer: UIGestureRecognizer)
    {
//
    }
    
    
    @IBAction func selectPic(_ sender: Any) {
        //here I want to execute the UIActionSheet
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

//        actionsheet.addAction(UIAlertAction(title: "Take a Photo", style: UIAlertAction.Style.default, handler: { (action) -> Void in
//                self.imageUplaod()
//                }))

        actionsheet.addAction(UIAlertAction(title: "Choose an Avatar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            let object = SelectAvatarVC.initialization()
            object.showPopup(usingModel: "") { (status, val) in
                if status == true{
                    self.profileImage.contentMode = .scaleAspectFill
                    self.profileImage.image = UIImage(named: val ?? "")
                }
                }
                }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in

                }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    
    func imageUplaod()
    {
        
        CameraBuffer().pickImage(self){ image in
            DispatchQueue.main.async {
                let data = image.jpegData(compressionQuality: 0.4)
                let parameters: [String : Any] = ["file": data!, "id": UserDefaults.getUserData?.customerID ?? 0]
                let url = baseURL.baseURl+subURL.uploadImage
                requestWith(url: url, imageData: data!, parameters: parameters, onCompletion: { Bool, url  in
                                if Bool == true{
                                    self.profileImage.image = image
                }})
                self.profileImage.contentMode = .scaleAspectFill
                self.profileImage.image = image
            }
        }
    }
    
    @IBAction func myOrder(_ sender: Any) {
        let viewController: HistoryVC = HistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func myTransaction(_ sender: Any) {
        let viewController: TransactionHistoryVC  = TransactionHistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func voucherHistory(_ sender: Any) {
        let viewController: VoucherHistoryVC  = VoucherHistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func faceDetect(_ sender: Any) {
        self.securitySettings()
    }
    
    
    @IBAction func contactUS(_ sender: Any) {
        self.navigationController?.pushViewController(ContactUSVC(), animated: true)

        
    }
    
     func securitySettings() {
        
        if AccessControl.isAuthenticationSupported() {
            let settingScreen: SettingScreen =  SettingScreen()
            self.navigationController?.pushViewController(settingScreen, animated: true)
            
        } else {
            self.showAlert(withTitle: Constants.kApplicationName, message: Constants.kErrorOldDevice)
        }
    }
    @IBAction func help(_ sender: Any) {
        let vc = LTWebView(nibName: "LTWebView", bundle: nil)
        vc.url = baseURL.helpAndSupport
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func referFriend(_ sender: Any) {
        let viewController: ReferAppVC = ReferAppVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func diableUser() {
        let model = DeleteAccountModel.init(customerID: UserDefaults.getUserData?.customerID, isUserDisabled: true, disabledRemarks: "")
            
        viewModel?.disabledUser(model: model, complition: { status, Msg in
            if status == true{
                self.alert(message: Msg, title: "")
            }
            else{
                self.showAlert(withTitle: "Alert", message: Msg)
            }
        })
        
        
    }
    @IBAction func deleteButton(_ sender: Any) {
        
        let alertController =
        UIAlertController(title: "", message: "If you delete your account permanently, you will not able to get retrive current balance in the app. Do you still want to proceed?", preferredStyle: .alert)
            // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            self.diableUser()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            // Add the actions
        alertController.view.tintColor = .systemBlue
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: "Security Reset. Please log in again", preferredStyle: .alert)
            // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                UIAlertAction in
                appDelegate.setupLogout()
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            // Add the actions
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .Profile:
            self.navigationController?.pushViewController(HistoryVC(), animated: true)
        case .History:
            self.navigationController?.pushViewController(HistoryVC(), animated: true)
        case .Helpline:
            let vc = LTWebView(nibName: "LTWebView", bundle: nil)
            vc.url = baseURL.imageBaseURl 
            self.navigationController?.pushViewController(vc, animated: true)
        case .Privacy:
            let vc = LTWebView(nibName: "LTWebView", bundle: nil)
            vc.url = baseURL.imageBaseURl
            self.navigationController?.pushViewController(vc, animated: true)
        case .Logout:
            self.navigationController?.pushViewController(LTWebView(), animated: true)
            
        }
    }
  

}


