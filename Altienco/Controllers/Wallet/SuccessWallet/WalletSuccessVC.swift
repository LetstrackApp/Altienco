//
//  WalletSuccessVC.swift
//  Altienco
//
//  Created by Ashish on 25/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class WalletSuccessVC: UIViewController {

    var denominationPrice = 0
    var walletBalance = 0
    var pincode = ""
    var isFromGatway = false
    var addMoneyViewModel : AddMoneyViewModel?
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 5
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
            self.viewContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var addMoney: LoadingButton!{
        didSet{
            DispatchQueue.main.async {
                self.addMoney.setupNextButton(title: "CONTINUE TO ADD MONEY")
            }
        }
    }
    
    
    @IBOutlet weak var successImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
            self.profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            self.profileImage.layer.borderColor = appColor.lightGrayBack.cgColor
            self.profileImage.layer.borderWidth = 1.0
            self.profileImage.contentMode = .scaleToFill // OR .scaleAspectFill
            self.profileImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var walletbalance: UILabel!
    @IBOutlet weak var denominationValue: UILabel!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addMoneyViewModel = AddMoneyViewModel()
        successImageView.rotate(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.successImageView.stopRotating()
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
        self.updateProfilePic()
        self.showNotify()
    }
    func showNotify(){
        if UserDefaults.isNotificationRead == "1"{
            self.notificationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notificationIcon.image = UIImage(named: "ic_notification")
        }
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
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletbalance.text = "\(currencySymbol)" + "\(walletAmount)"
            self.denominationValue.text = "\(currencySymbol)" + "\(self.denominationPrice)"
        }
       (self.isFromGatway == true) ? (self.addMoney.isHidden = true) : (self.addMoney.isHidden = false)
         
    }
    
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backView(_ sender: Any) {
        self.addMoney.showLoading()
        self.addMoney.hideLoading()
        
        let dataModel = AddMoneyModel.init(pinNumber: pincode, langCode: "en", transactionTypeID: 1, customerId: UserDefaults.getUserData?.customerID ?? 0)
        addMoneyViewModel?.addMoney(model: dataModel) { (result, status)  in
                    DispatchQueue.main.async { [weak self] in
                        if  (result != nil) && status == true{
//                            self?.callSuccessPopup(Msg: "", cardValue: result?.cardValue ?? 0, walletBalance: result?.walletAmount ?? 0.0)
                        }
                    }}
            
    }
    
//    func callSuccessPopup(Msg: String, cardValue: Int, walletBalance: Double){
//        let object = CongoPopupVC.initialization()
//        object.showAlert(usingModel: Msg, cardValue: cardValue, walletBalance: walletBalance) { (val) in
//            if val == 1{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                if let topController = UIApplication.topViewController() {
//                    topController.navigationController?.popViewController(animated: false)
//                }
//            })}
//            else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                if let topController = UIApplication.topViewController() {
//                    topController.navigationController?.popToRootViewController(animated: true)
//                }
//            })}
//        }
//
//    }
    
}
