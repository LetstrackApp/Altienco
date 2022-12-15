//
//  ProfileVC.swift
//  Altienco
//
//  Created by Ashish on 07/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    var profileImage = ""
    var isAvatarImage = false
    var isTextEditing = false
    var registerUser : RegistrationViewModel?
    @IBOutlet weak var userImage: UIImageView!{
        didSet{
            self.userImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            self.userImage.contentMode = .scaleAspectFit // OR .scaleAspectFill
            self.userImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var doneButton: UIButton!{
        didSet{
            self.doneButton.setupNextButton(title: "Done")
        }
    }
    @IBOutlet weak var imageContainer: UIView!{
        didSet{
            imageContainer.layer.cornerRadius = imageContainer.frame.height/2
            imageContainer.clipsToBounds=true
            imageContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            imageContainer.layer.borderWidth = 1.0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerUser = RegistrationViewModel()
        self.initializeView()
        self.initializeValue()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectPic(_ sender: Any) {
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
                    self.updateProfilePic()
                    
                }
                }
                }))
        actionsheet.addAction(UIAlertAction(title: "Choose a Photo", style: UIAlertAction.Style.default, handler: { (action) -> Void in
//            self.alert(message: "Coming soon..")
                self.imageUplaod()
                }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in

                }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    
    @IBAction func editFirstName(_ sender: Any) {
        self.firstName.isEnabled = true
        self.firstName.becomeFirstResponder()
    }
    @IBAction func editLastName(_ sender: Any) {
        self.lastName.isEnabled = true
        self.lastName.becomeFirstResponder()
    }
    @IBAction func editEmail(_ sender: Any) {
        self.emailID.isEnabled = true
        self.emailID.becomeFirstResponder()
    }
    
    
    
    @IBAction func updateData(_ sender: Any) {
        guard let image = UserDefaults.getUserData?.profileImage else {return}
        self.profileImage = image
        self.firstName.text = firstName.text?.trimmingCharacters(in: .whitespaces)
        self.lastName.text = lastName.text?.trimmingCharacters(in: .whitespaces)
        self.emailID.text = emailID.text?.trimmingCharacters(in: .whitespaces)
        if self.isTextEditing == true{
            if self.isValid(testStr: firstName.text ?? "") == false {
                self.alert(message: "Detials Invalid. Please enter first name")
            }
            else if self.isValid(testStr: lastName.text ?? "") == false{
                self.alert(message: "Detials Invalid. Please enter last name")
            }
            else if self.isValidEmail(testStr: emailID.text ?? "") == false{
                self.alert(message: "Details Invalid. Please enter valid email")
            }
            else if self.profileImage == ""{
                self.alert(message: "Please select a photo or an avatar")
            }
            else{
            self.updateProfilePic()
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateProfilePic(){
        
        if self.profileImage != ""{
            let dataModel = RegistrationModel.init(mobileCode: UserDefaults.getMobileCode, mobileNumber: UserDefaults.getMobileNumber, profileImage: self.profileImage, countryCode: UserDefaults.getCountryCode, firstName: firstName.text, lastName: lastName.text, emailID: emailID.text, referredCode: "", langCode: "en", isAvatarImage: self.isAvatarImage)
            self.registerUser?.registerUser(model: dataModel) { (result, status, message)  in
                DispatchQueue.main.async { [weak self] in
                    if status == true, (result != nil){
                        self?.isTextEditing = false
                        Helper.showToast("Great. Profile now updated.", delay: Helper.DELAY_SHORT)
                    }
                    else{
                        self?.alert(message: message, title: "Alert")
                    }
                }

        }
        
    }
        else {
            self.alert(message: "Please select a photo or an avatar", title: "Alert")
        }
    }
    
    
    func imageUplaod()
    {
        
        CameraBuffer().pickImage(self){ image in
            DispatchQueue.main.async {
                let data = image.jpegData(compressionQuality: 0.4)
                let parameters: [String : Any] = ["file": data!, "id": UserDefaults.getUserData?.customerID ?? 0]
//                ["files": data!, "imageName": UserDefaults.getUserData?.firstName ?? "" + "Profile", "imageType":"USERPROFILE", "id": ""]
                let url = baseURL.baseURl + subURL.uploadImage
                requestWith(url: url, imageData: data!, parameters: parameters, onCompletion: { Bool, url in
                                if Bool == true{
                                    self.setupProfileImage(url: url ?? "")
                                    self.userImage.contentMode = .scaleAspectFill
                                    self.userImage.image = image
                                }})
                self.userImage.contentMode = .scaleAspectFill
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

    
    func initializeValue()
    {
        if UserDefaults.getUserData?.firstName != ""
        {
            firstName.text = UserDefaults.getUserData?.firstName
            lastName.text = UserDefaults.getUserData?.lastName ?? ""
            emailID.text = UserDefaults.getUserData?.emailID
        }
        if (UserDefaults.getUserData?.profileImage) != nil
        {
            
            if let aString = UserDefaults.getUserData?.profileImage
            {
                if UserDefaults.getAvtarImage == "1"{
                    self.userImage.contentMode = .scaleAspectFit
                    self.userImage.image = UIImage(named: aString)
                }else{
                let newString = aString.replacingOccurrences(of: baseURL.imageURL, with: baseURL.imageBaseURl, options: .literal, range: nil)
                self.userImage.contentMode = .scaleToFill
                self.userImage.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "defaultUser"))
                }
            }
        }
    }
    
    
    
    func initializeView()
    {
        self.setupNav(title: "")
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(self.action), for: .touchUpInside)
        button.sizeToFit()
        button.tintColor = .black
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: button)
    }
    
    @objc func action(){
        self.navigationController?.popViewController(animated: true)
    }
}


extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.isTextEditing = true
            }
        
        
        return true
    }
}



extension ProfileVC{
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
}
