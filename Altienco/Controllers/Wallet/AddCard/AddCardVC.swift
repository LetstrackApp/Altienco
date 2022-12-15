//
//  AddCardVC.swift
//  Altienco
//
//  Created by Ashish on 25/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController, UITextFieldDelegate, GoToRootDelegate {
    func CloseToRoot(dismiss: Bool) {
        if dismiss{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if let topController = UIApplication.topViewController() {
                    topController.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    //    var verifyPinViewModel : VerifyPinViewModel?
    var addMoneyViewModel : AddMoneyViewModel?
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.layer.cornerRadius = 8.0
            viewContainer.clipsToBounds=true
            viewContainer.dropShadow(shadowRadius: 2, offsetSize: CGSize(width: 0, height: 0), shadowOpacity: 0.3, shadowColor: .black)
        }
    }
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
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    
    @IBOutlet weak var cardPinText: UITextField!{didSet{
        self.cardPinText.font = UIFont.SF_Bold(20.0)
        self.cardPinText.textColor = appColor.blackText
    }}
    
    @IBOutlet weak var verifyPin: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.verifyPin.setupNextButton(title: "VERIFY PIN")
            }
        }
    }
    
    @IBOutlet weak var notificationIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMoneyViewModel = AddMoneyViewModel()
        //        verifyPinViewModel = VerifyPinViewModel()
        self.cardPinText.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
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
            self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didChangeText(textField:UITextField) {
        cardPinText.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (cardPinText.text ?? "").count + string.count - range.length
        if(textField == cardPinText) {
            return newLength <= 19
        }
        return true
    }
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    @IBAction func backView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func verifyPin(_ sender: Any) {
        var pincode = self.cardPinText.text!
        if self.cardPinText.text?.count != 19{
            let vc: FailureWalletVC = FailureWalletVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.view.backgroundColor = .clear
            self.present(vc, animated: false, completion: nil)
        }
        else{
            pincode = pincode.replacingOccurrences(of: " ", with: "")
            let dataModel = AddMoneyModel.init(pinNumber: pincode, langCode: "en", transactionTypeID: 1, customerId: UserDefaults.getUserData?.customerID ?? 0)
            addMoneyViewModel?.addMoney(model: dataModel) { (result, status)  in
                DispatchQueue.main.async { [weak self] in
                    if  (result != nil) && status == true{
                        self?.callSuccessPopup(Msg: "", cardValue: result?.cardValue ?? 0, walletBalance: result?.walletAmount ?? 0.0)
                    }
                    else{
                        let viewController: FailureWalletVC = FailureWalletVC()
                        viewController.modalPresentationStyle = .overFullScreen
                        self?.navigationController?.present(viewController, animated: true)
                    }
                }}
        }
    }
    
    
    func callSuccessPopup(Msg: String, cardValue: Int, walletBalance: Double){
        
        let viewController: CongoPopupVC = CongoPopupVC()
        viewController.walletBalance = walletBalance
        viewController.Message = Msg
        viewController.cardValue = cardValue
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        self.navigationController?.present(viewController, animated: true)
    }
}




