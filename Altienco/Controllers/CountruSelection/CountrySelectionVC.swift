//
//  CountrySelectionVC.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import DropDown
class CountrySelectionVC: UIViewController {
    
    var viewModel: GenerateOTPViewModel?
    let dropDown = DropDown()
    
    
    @IBOutlet weak var countrySCTitle: UILabel!{
        didSet{
            countrySCTitle.font = UIFont.SF_Medium(24.0)
            countrySCTitle.textColor = appColor.blackText
        }
    }
    
    @IBOutlet weak var mobileTExt: UILabel!{
        didSet{
            mobileTExt.font = UIFont.SFPro_Light(16.0)
            mobileTExt.setCharacterSpacing(0)
        }
    }
    @IBOutlet weak var mobileNumber: TextField!{
        didSet{
            mobileNumber.layer.cornerRadius = 8
            mobileNumber.layer.borderWidth = 1
            mobileNumber.layer.borderColor =  UIColor.init(0xe1f5fc).cgColor
            mobileNumber.font = UIFont.SF_Regular(16.0)
            mobileNumber.textContentType = .telephoneNumber
            mobileNumber.textColor = appColor.blackText
            mobileNumber.defaultTextAttributes.updateValue(3.7,
                                                           forKey: NSAttributedString.Key.kern)
            mobileNumber.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
            
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
            self.viewContainer.layer.shadowRadius = 5
            self.viewContainer.layer.shadowOffset = .zero
            self.viewContainer.layer.shadowOpacity = 1
            self.viewContainer.layer.cornerRadius = 15.0
            self.viewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var numberViewContainer: UIView!{
        didSet{
            numberViewContainer.layer.cornerRadius = 6.0
            numberViewContainer.clipsToBounds=true
            numberViewContainer.dropShadow(color: appColor.lightGrayBack,
                                           opacity: 0.2,
                                           offSet: CGSize(width: 0, height: 0),
                                           radius: 2, scale: true)
        }
    }
    @IBOutlet weak var countryPickerView: UIView!{
        didSet{
            countryPickerView.layer.cornerRadius = 6.0
            countryPickerView.addTarget(target: self, action: #selector(chooseCountry(_:)))
            
        }
    }
    @IBOutlet weak var nextButton: LoadingButton!{
        didSet{
            self.nextButton.setupNextButton(title: lngConst.proceed)
        }
    }
    @IBOutlet weak var countryCodeLabel: UILabel!{
        didSet{
            countryCodeLabel.font = UIFont.SF_Regular(16.0)
            countryCodeLabel.textColor = UIColor.init(0x2b2a29)
        }
    }
    
    @IBOutlet weak var flagIcon: UIImageView!{
        didSet{
            flagIcon.image = UIImage(named: "Flag_1")
            flagIcon.layer.cornerRadius = flagIcon.frame.height/2
            flagIcon.clipsToBounds=true
        }
    }
    @IBOutlet weak var languageLbl: UILabel!{
        didSet {
            languageLbl.font = UIFont.SF_Regular(14)
        }
    }
    
    @IBOutlet weak var languageSlectionView: UIView!{
        didSet {
            languageSlectionView.layer.cornerRadius = 15
            languageSlectionView.layer.borderWidth = 1
            languageSlectionView.layer.borderColor = UIColor.init(0xa4a4a4).cgColor
            languageSlectionView.addTarget(target: self, action: #selector(languageChangeAction(_:)))
        }
    }
    
    convenience init() {
        self.init(nibName: "CountrySelectionVC", bundle: nil)
        self.viewModel = GenerateOTPViewModel()
        if UserDefaults.getMobileCode.isEmpty {
            UserDefaults.setMobileCode(data: CountryCode.UK.rawValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropDown.direction = .bottom
        onLanguageChange()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: languageSlectionView)
    }
    
    
    private func onLanguageChange() {
        self.view.endEditing(true)
        mobileTExt.text = lngConst.verificationHint
        countrySCTitle.text = lngConst.phoneNumber
        languageLbl.text = "EN"
        nextButton.setTitle(lngConst.proceed, for: .normal)
        countryCodeLabel.text = UserDefaults.getMobileCode
    }
    
    @IBAction func languageChangeAction(_ sender: Any) {
        self.view.endEditing(true)
        viewModel?.showDropDown(view: languageSlectionView,
                                stringArry: ["EN"]) {  [weak self] index, result in
            self?.languageLbl.text = result
            self?.onLanguageChange()
        }
    }
    
    
    
    @IBAction func chooseCountry(_ sender: Any) {
        self.view.endEditing(true)
        self.customizeDropDown()
    }
    
    
    
    @IBAction func sentOTP(_ sender: Any) {
        Helper.hideToast()
        self.view.endEditing(true)
        if  Validator.isValidMobile(mobileNumber) == true {
            mobileNumber.setError()
            registerUser()
        }
    }
    
    
    private func registerUser() {
        self.nextButton.showLoading()
        self.view.isUserInteractionEnabled = false
        UserDefaults.setCountryCode(data: CountryCode.init(rawValue: UserDefaults.getMobileCode)?.ISOcode ?? "GBR")
        let dataModel = GenerateOTP.init(langCode: "Eng",
                                         mobileCode: "\(UserDefaults.getMobileCode)",
                                         mobileNumber: self.mobileNumber.text!,
                                         deviceId: UIDevice.current.description,
                                         deviceType: "1",
                                         deviceOSVersion: UIDevice.current.model,
                                         buildVersion: "1.0.0")
        
        viewModel?.generateOTP(model: dataModel) { (result)  in
            DispatchQueue.main.async { [weak self] in
                self?.view.isUserInteractionEnabled = true
                self?.nextButton.hideLoading()
                if  (result != nil) {
                    self?.redirectBussines(userid: 0)
                    UserDefaults.setMobileNumber(data: (self?.mobileNumber.text!)!)
                }
            }
        }
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
            
            UserDefaults.setMobileCode(data: index == 0 ?  CountryCode.IN.rawValue : CountryCode.UK.rawValue)
            self?.countryCodeLabel.text = UserDefaults.getMobileCode
            
        }
        dropDown.show()
    }
    
}

//MARK: - Routing
extension CountrySelectionVC {
    
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
    
}

//MARK: - UITextFieldDelegate
extension CountrySelectionVC: UITextFieldDelegate {
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
      
        
        if textField == mobileNumber{
            let disallowedCharacterSet = NSCharacterSet(charactersIn:textfiledchar.circleCode).inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            result = replacementStringIsLegal
        }
        
        if (textField == mobileNumber) && result == true {
            return newString.count <= 10
        }
       
        return result
    }
    
    
    func fontChange(_ textField: UITextField){
        if textField.text?.count ?? 0 > 0 {
            textField.font = UIFont.SF_Medium(20.0)
        }else {
            textField.font = UIFont.SF_Regular(16.0)
        }
    }
    
    @objc func handleTextFieldDidChange(_ textField: UITextField) {
        fontChange(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fontChange(textField)
        textField.setError()
        //        Validator.isValidEmail(field: textField, show: false)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let paste = UIPasteboard.general.string, text == paste {
            print("paste")
        } else {
            print("normal typing")
        }
        
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        textField.setError()
//        let newLength = (mobileNumber.text ?? "").count + string.count - range.length
//        if(textField == mobileNumber) {
//            return newLength <= 13
//        }
//        
//        return true
//    }
}
