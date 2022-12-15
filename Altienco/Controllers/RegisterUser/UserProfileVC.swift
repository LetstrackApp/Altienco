//
//  UserProfileVC.swift
//  LMDispatcher
//
//  Created by APPLE on 16/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class UserProfileVC: UIViewController {
    
    var userModel : UserModel?
    var registerUser : RegistrationViewModel?
    var window = UIWindow()
    var profileImage = ""
    var agree: Bool = false
    var isAvatarImage = false
    
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var FnameErrorView: UIView!
    @IBOutlet weak var lNameErrorView: UIView!
    @IBOutlet weak var emailDialog: UILabel!
    @IBOutlet weak var firstNameDialog: UILabel!
    @IBOutlet weak var lastNameDialog: UILabel!
    @IBOutlet weak var firstRCodeView: UIView!{
        didSet{
            firstRCodeView.layer.cornerRadius = 6.0
            firstRCodeView.layer.borderColor = appColor.otpBorderColor.cgColor
            firstRCodeView.layer.borderWidth = 1
            firstRCodeView.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var secondRCodeView: UIView!{
        didSet{
            secondRCodeView.layer.cornerRadius = 6.0
            secondRCodeView.layer.borderColor = appColor.otpBorderColor.cgColor
            secondRCodeView.layer.borderWidth = 1
            secondRCodeView.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var thirdRCodeView: UIView!{
        didSet{
            thirdRCodeView.layer.cornerRadius = 6.0
            thirdRCodeView.layer.borderColor = appColor.otpBorderColor.cgColor
            thirdRCodeView.layer.borderWidth = 1
            thirdRCodeView.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var fourthRCodeView: UIView!{
        didSet{
            fourthRCodeView.layer.cornerRadius = 6.0
            fourthRCodeView.layer.borderColor = appColor.otpBorderColor.cgColor
            fourthRCodeView.layer.borderWidth = 1
            fourthRCodeView.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var fifthRCodeView: UIView!{
        didSet{
            fifthRCodeView.layer.cornerRadius = 6.0
            fifthRCodeView.layer.borderColor = appColor.otpBorderColor.cgColor
            fifthRCodeView.layer.borderWidth = 1
            fifthRCodeView.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 6
                self.viewContainer.layer.borderColor = appColor.lightGrayBack.cgColor
                self.viewContainer.layer.borderWidth = 1.0
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 15.0
                self.viewContainer.clipsToBounds=true
            }
        }
    }
    
    @IBOutlet weak var imageVIew: UIView!{
        didSet{
            imageVIew.layer.cornerRadius = 8.0
            imageVIew.clipsToBounds=true
            imageVIew.layer.borderColor = appColor.otpBorderColor.cgColor
            imageVIew.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var acceptConditions: UIButton!{
        didSet{
            acceptConditions.setImage(UIImage(named: "UncheckSquare"), for: .normal)
            acceptConditions.setImage(UIImage(named: "CheckSquare"), for: .selected)
        }
    }
    @IBOutlet weak var firstMessage: PaddingLabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addPhoto: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
                self.nextButton.setupNextButton(title: lngConst.register)
        }
    }
    @IBOutlet weak var textFeildConatiner: UIView!{
        didSet{
            textFeildConatiner.layer.cornerRadius = 8.0
            textFeildConatiner.clipsToBounds=true
            
        }
    }
    
    @IBOutlet weak var textFeildConatiner2: UIView!{
        didSet{
            textFeildConatiner2.layer.cornerRadius = 8.0
            textFeildConatiner2.clipsToBounds=true
            
        }
    }
    @IBOutlet weak var textFeildConatiner3: UIView!{
        didSet{
            textFeildConatiner3.layer.cornerRadius = 8.0
            textFeildConatiner3.clipsToBounds=true
        }
    }

    
    @IBOutlet weak var firstName: UITextField!{
        didSet{
            firstName.autocapitalizationType = .words
            firstName.font = UIFont.SF_Regular(16.0)
            firstName.textColor = appColor.blackText
        }
    }
    
    
    @IBOutlet weak var lastname: UITextField!{
        didSet{
            lastname.autocapitalizationType = .allCharacters
            lastname.font = UIFont.SF_Regular(16.0)
            lastname.textColor = appColor.blackText
        }
    }
    
    @IBOutlet weak var emailAddress: UITextField!{
        didSet{
            emailAddress.autocapitalizationType = .sentences
            emailAddress.font = UIFont.SF_Regular(16.0)
            emailAddress.textColor = appColor.blackText
        }
    }
    
    @IBOutlet var textFields: [BackTextField]!
    func isValid(testStr:String) -> Bool {
        guard testStr.count > 2, testStr.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
    func isValidEmail(testStr:String) -> Bool {
                print("validate emilId: \(testStr)")
                let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                let result = emailTest.evaluate(with: testStr)
                return result
            }
    func setupTextBox(){
        self.FnameErrorView.isHidden=true
        self.lNameErrorView.isHidden=true
        self.emailErrorView.isHidden=true
    }
    
    @IBAction func startTracking(_ sender: Any) {
        self.setupTextBox()
        var inviteCode = ""
        for txtField in textFields {
             if let text = txtField.text {
                inviteCode += text
            }
        }
        self.firstName.text = firstName.text?.trimmingCharacters(in: .whitespaces)
        self.lastname.text = lastname.text?.trimmingCharacters(in: .whitespaces)
        self.emailAddress.text = emailAddress.text?.trimmingCharacters(in: .whitespaces)
        
        if self.isValid(testStr: firstName.text ?? "") == false {
            self.FnameErrorView.isHidden = false
            self.firstNameDialog.text = "Detials Invalid. Please enter first name"
            
        }
        else if self.isValid(testStr: lastname.text ?? "") == false{
            self.lNameErrorView.isHidden = false
            self.lastNameDialog.text = "Detials Invalid. Please enter last name"
        }
        else if self.isValidEmail(testStr: emailAddress.text ?? "") == false{
            self.emailErrorView.isHidden = false
            self.emailDialog.text = "Details Invalid. Please enter valid email "
        }
        else if self.profileImage == ""{
            self.alert(message: "Please select a photo or an avatar")
        }
        else if self.agree == false{
            self.alert(message: "Please confirm the terms & conditions")
        }
        else{
            let dataModel = RegistrationModel.init(mobileCode: UserDefaults.getMobileCode, mobileNumber: UserDefaults.getMobileNumber, profileImage: self.profileImage, countryCode: UserDefaults.getCountryCode, firstName: firstName.text, lastName: lastname.text, emailID: emailAddress.text, referredCode: inviteCode, langCode: "en", isAvatarImage: self.isAvatarImage)
            self.registerUser?.registerUser(model: dataModel) { (result, status, message)  in
                DispatchQueue.main.async { [weak self] in
                    if status == true, (result != nil){
                        self?.redirectDashboard()
                    }
                    else{
                        self?.alert(message: message, title: "Alert")
                    }
                } }
         }
    }
    
    func redirectDashboard(){
        appDelegate.initialPoint(Controller: DashboardVC())
    }
    
    
    @IBAction func selectCamera(_ sender: Any) {
        //here I want to execute the UIActionSheet
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        
        actionsheet.addAction(UIAlertAction(title: "Choose an Avatar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            let object = SelectAvatarVC.initialization()
            object.showPopup(usingModel: "") { (status, val) in
                if status == true{
                    self.userImage.contentMode = .scaleAspectFill
                    self.userImage.image = UIImage(named: val ?? "")
                    self.profileImage = val ?? ""
                    self.isAvatarImage = true
                    self.addPhoto.setImage(nil, for: .normal)
                }
                }
                }))
        actionsheet.addAction(UIAlertAction(title: "Choose a Photo", style: UIAlertAction.Style.default, handler: { (action) -> Void in
//            self.alert(message: "Coming soon..")
            
                self.imageUplaod()
            self.userImage.contentMode = .scaleToFill
                }))

        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in

                }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func termsButton(_ sender: Any) {
        
        let vc = LTWebView(nibName: "LTWebView", bundle: nil)
        vc.url = baseURL.termsCondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var UItextView: UIView!{
        didSet{
            UItextView.layer.cornerRadius = 6.0
        }
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
                        self.addPhoto.setImage(nil, for: .normal)
                        self.profileImage = url ?? ""
                        self.setupProfileImage(url: url ?? "")
                        self.userImage.image = image
                    }})
                self.addPhoto.setImage(nil, for: .normal)
//                self.photoAdded.isHidden=false
                self.userImage.image = image
            }
        }
    }
    
    func setupProfileImage(url: String){
        var model = UserDefaults.getUserData
        UserDefaults.setAvtarImage(data: false)
        model?.profileImage = url
        if model != nil{
            UserDefaults.setUserData(data: model!)
            if let profileImage = UserDefaults.getUserData?.profileImage{
                self.userImage.contentMode = .scaleToFill
                self.userImage.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "defaultUser"))
            }
        }
        
    }
    
   
    
    @IBAction func selectAgree(_ sender: Any) {
        
        if agree == true{
            self.agree = false
            self.acceptConditions.isSelected = false
        }
        else{
            self.agree = true
            self.acceptConditions.isSelected = true
        }
    }

  
    override func viewDidLoad(){
        super.viewDidLoad()
        self.userModel = UserModel()
        self.registerUser = RegistrationViewModel()
        self.firstMessage.text = "\(UserDefaults.getMobileCode) \(UserDefaults.getMobileNumber)"
        DispatchQueue.main.async {
            self.setupTextBox()
            self.setTextField()
        }
        // Do any additional setup after loading the view.
    }
}



extension UserProfileVC: UITextFieldDelegate, BackFieldDelegate{
    func textFieldDidDelete(textField : BackTextField){
        if let txtField = self.view.viewWithTag(textField.tag-1) {
            txtField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstName{
            firstName.text?.capitalizeFirstLetter()
        }
        else if textField == lastname{
            lastname.text?.capitalizeFirstLetter()
        }
        else if textField == emailAddress{
            emailAddress.text?.lowercased()
        }
        self.setupTextBox()
        return true
    }
    // Set textfields
    func setTextField(){
        for txtField in textFields {
            txtField.backDelegate = self
            
            txtField.contentVerticalAlignment = .center
            txtField.textAlignment = .center
            txtField.textColor = appColor.blackText
            
            txtField.textAlignment = .center
            txtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
//        setupReferalCode()
    }
    @objc func textFieldDidChange(textField: UITextField){
        if textField.text?.trimWhiteSpace.length ?? 0 > 0 {
            if let txtField = self.view.viewWithTag(textField.tag+1) {
                txtField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
//    func setupReferalCode(){
//        guard let referalCode = UserDefaults.getUserData?.customerCode,referalCode.length == 5 else {return}
//        if let firstTextField = view.viewWithTag(100) as? UITextField {
//            firstTextField.text = referalCode[0]
//        }
//        if let secondTextField = view.viewWithTag(101) as? UITextField {
//            secondTextField.text = referalCode[1]
//        }
//        if let thirdTextField = view.viewWithTag(102) as? UITextField {
//            thirdTextField.text = referalCode[2]
//        }
//        if let forthTextField = view.viewWithTag(103) as? UITextField {
//            forthTextField.text = referalCode[3]
//        }
//        if let fifthTextField = view.viewWithTag(104) as? UITextField {
//            fifthTextField.text = referalCode[4]
//        }
//    }
}


extension String{
    var trimWhiteSpace: String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmedString
    }
    var length: Int {
        return self.count
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
