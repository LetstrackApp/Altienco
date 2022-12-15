//
//  CountrySelectionVC.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import Localize_Swift
import IQKeyboardManagerSwift
import DropDown

class CountrySelectionVC: UIViewController, UITextFieldDelegate {
    
    var generateOTPViewModel: GenerateOTPViewModel?
    let dropDown = DropDown()
    var countryCode = "GBR"
    var mobileCode = "+44"
    @IBOutlet weak var countrySCTitle: UILabel!{
        didSet{
            countrySCTitle.text = "Phone Number"
            countrySCTitle.font = UIFont.SF_Medium(24.0)
            countrySCTitle.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var mobileTExt: UILabel!{
        didSet{
            mobileTExt.text = "We may send a verification code to this number"
//            mobileTExt.text = lngConst.mobile.capitalized
            mobileTExt.font = UIFont.SFPro_Light(16.0)
            mobileTExt.setCharacterSpacing(0)
        }
    }
    @IBOutlet weak var mobileNumber: UITextField!{
        didSet{
            mobileNumber.font = UIFont.SF_Bold(20.0)
            mobileNumber.tintColor = appColor.blackText
            mobileNumber.textContentType = .telephoneNumber
            mobileNumber.textColor = appColor.blackText
            mobileNumber.defaultTextAttributes.updateValue(7.0,
                 forKey: NSAttributedString.Key.kern)
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 5
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 15.0
                self.viewContainer.clipsToBounds=true
            }
            self.viewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var numberViewContainer: UIView!{
        didSet{
            numberViewContainer.layer.cornerRadius = 6.0
            numberViewContainer.clipsToBounds=true
            numberViewContainer.dropShadow(color: appColor.lightGrayBack, opacity: 0.2, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        }
    }
    @IBOutlet weak var countryPickerView: UIView!{
        didSet{
            countryPickerView.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.nextButton.setupNextButton(title: lngConst.proceed)
            }
        }
    }
    @IBOutlet weak var countryCodeLabel: UILabel!{
        didSet{
            countryCodeLabel.font = UIFont.SF_Regular(16.0)
            countryCodeLabel.text = mobileCode
            countryCodeLabel.textColor = appColor.lightGrayText
        }
    }
    
    @IBOutlet weak var flagIcon: UIImageView!{
        didSet{
            flagIcon.image = UIImage(named: "Flag_1")
            flagIcon.layer.cornerRadius = flagIcon.frame.height/2
            flagIcon.clipsToBounds=true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropDown.direction = .bottom
        generateOTPViewModel = GenerateOTPViewModel()
        // Do any additional setup aftshower loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let paste = UIPasteboard.general.string, text == paste {
           print("paste")
        } else {
           print("normal typing")
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.validationError.text = ""
         let newLength = (mobileNumber.text ?? "").count + string.count - range.length
         if(textField == mobileNumber) {
             return newLength <= 13
         }
        
         return true
    }
    
    func redirectBussines(userid: Int)  {
        self.view.endEditing(true)
        let object = VerifyOtpVC.initialization()
        object.showAlert(usingModel: userid) { (val) in
            DispatchQueue.main.async {
                if UserDefaults.getExistingUser == "1"{
                    self.redirectDashboard()
                }
                else{
                    self.redirectProfile()
                }
            }
        }
    }
    func redirectDashboard(){
        appDelegate.initialPoint(Controller: DashboardVC())
    }
    func redirectProfile()
    {
        let store = UserProfileVC()
        self.navigationController?.pushViewController(store, animated: true)
    }
    
    @IBOutlet weak var validationError: UILabel!
    @IBAction func chooseCountry(_ sender: Any) {
        self.customizeDropDown()
    }
    
    
    
    @IBAction func sentOTP(_ sender: Any) {
        if (mobileNumber.text!.count == CountryCode.IN.numberDigit) || mobileNumber.text!.count == CountryCode.UK.numberDigit
        {
            self.validationError.text = ""
            registerUser()
        }
        else
        {
            self.validationError.text = "Invalid entry, Please enter again."
        }
    }
    
    
    func registerUser()
    {
        UserDefaults.setCountryCode(data: self.countryCode)
        let dataModel = GenerateOTP.init(langCode: "Eng", mobileCode: "\(self.mobileCode)", mobileNumber: self.mobileNumber.text!, deviceId: UIDevice.current.description, deviceType: "1", deviceOSVersion: UIDevice.current.model, buildVersion: "1.0.0")
        generateOTPViewModel?.generateOTP(model: dataModel ) { (result)  in
            DispatchQueue.main.async { [weak self] in
                if  (result != nil){
                    self?.redirectBussines(userid: 0)
                    UserDefaults.setMobileCode(data: self?.countryCodeLabel.text! ?? "+91")
                    UserDefaults.setMobileNumber(data: (self?.mobileNumber.text!)!)
                }
            }}
        
        
    }
    
    
    func customizeDropDown() {
        dropDown.dataSource = ["India", "United Kingdom"]
        dropDown.direction = .bottom
        dropDown.width = 200
        dropDown.anchorView = self.countrySCTitle
//        dropDown.anchorView = view
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.cellNib = UINib(nibName: "CountryCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            // Setup your custom UI components
            cell.logoImageView.image = UIImage(named: "Flag_\(index)")
        }
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.flagIcon.image = UIImage(named: "Flag_\(index)")
            if index == 0
            {
                self?.countryCode = "IND"
                self?.mobileCode = CountryCode.IN.rawValue
                self?.countryCodeLabel.text = self?.mobileCode ?? ""
            }
    
            else{
                self?.countryCode = "GBR"
                self?.mobileCode = CountryCode.UK.rawValue
                self?.countryCodeLabel.text = self?.mobileCode ?? ""
            }
        }
        dropDown.show()
    }
    
}



