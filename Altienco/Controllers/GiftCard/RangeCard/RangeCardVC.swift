//
//  RangeCardVC.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class RangeCardVC: UIViewController {

    var countryModel : SearchCountryModel? = nil
    var language = "EN"
    var planType = 2
    var operatorID = 0
    var currentValue = 0.0
    var giftCardLogo = ""
    var backgroundCode : UIColor?
    var currencySymbol = ""
    var giftCardName = ""
    
    var viewModel : RangeCardViewModel?
    var filteredData: [RangeGiftCardResponse] = []
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 6
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var logoBackground: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.logoBackground.layer.shadowPath = UIBezierPath(rect: self.logoBackground.bounds).cgPath
                self.logoBackground.layer.shadowRadius = 5
                self.logoBackground.layer.shadowOffset = .zero
                self.logoBackground.layer.shadowOpacity = 1
                self.logoBackground.layer.cornerRadius = 8.0
                self.logoBackground.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = 5.0
            logoImage.layer.borderWidth = 1.0
            logoImage.layer.borderColor = appColor.lightGrayBack.cgColor
            logoImage.clipsToBounds=true
        }
    }
    @IBOutlet weak var minusButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.minusButton.layer.shadowPath = UIBezierPath(rect: self.minusButton.bounds).cgPath
                self.minusButton.layer.borderWidth = 1.0
                self.minusButton.layer.borderColor = appColor.lightGrayBack.cgColor
                self.minusButton.layer.cornerRadius = 8.0
                self.minusButton.backgroundColor = .white
                self.minusButton.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var numberContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.numberContainer.layer.shadowPath = UIBezierPath(rect: self.numberContainer.bounds).cgPath
                self.numberContainer.layer.borderWidth = 1.0
                self.numberContainer.layer.borderColor = appColor.lightGrayBack.cgColor
                self.numberContainer.layer.cornerRadius = 8.0
                self.numberContainer.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var plusButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.plusButton.layer.shadowPath = UIBezierPath(rect: self.plusButton.bounds).cgPath
                self.plusButton.layer.borderWidth = 1.0
                self.plusButton.layer.borderColor = appColor.lightGrayBack.cgColor
                self.plusButton.layer.cornerRadius = 8.0
                self.plusButton.backgroundColor = .white
                self.plusButton.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var planAmount: UITextField!
    @IBOutlet weak var planDesc: UILabel!
    @IBOutlet weak var viewMoreConatiner: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var moreTextContainer: UIView!
    @IBOutlet weak var moreText: UILabel!
    
    @IBOutlet weak var descActionText: UILabel!
    @IBOutlet weak var hideDesc: UIButton!
    @IBOutlet weak var generateCardButton: UIButton!{
        didSet{
            generateCardButton.setupNextButton(title: "GENERATE GIFT CARD")
        }
    }
    @IBOutlet weak var displayCurreny: UILabel!
    @IBOutlet weak var boxWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var showRangeText: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RangeCardViewModel()
        self.initiateModel()
        self.setupView()
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showNotify()
        self.updateProfilePic()
        self.setupValue()
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
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
    }
    func showNotify(){
        if UserDefaults.isNotificationRead == "1"{
            self.notificationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notificationIcon.image = UIImage(named: "ic_notification")
        }
    }
    
    func setupView(){
        if giftCardLogo != "" {
            self.logoImage.sd_setImage(with: URL(string: giftCardLogo), placeholderImage: UIImage(named: "ic_operatorLogo"))
        }
        else{
            self.logoImage.image = UIImage(named: "ic_operatorLogo")
        }
        
    
    }
    
    func showDescription(){
        if let details = filteredData.first?.objDescription{
            self.detailLabel.text = details
        }
        if let usageInfo = filteredData.first?.usageInfo{
            self.moreText.text = usageInfo
            self.viewMoreConatiner.isHidden = false
            self.moreTextContainer.isHidden = false
        }
        else{
            self.viewMoreConatiner.isHidden = true
            self.moreTextContainer.isHidden = true
        }
    }
    var showMoreClicked = false
    @IBAction func showMoreDesc(_ sender: Any) {
        if self.showMoreClicked == false{  self.showMoreClicked = true
            self.moreTextContainer.isHidden = false
//            self.descActionText.text = "Hide"
        }else{
            self.showMoreClicked = false
            self.moreTextContainer.isHidden = true
//            self.descActionText.text = "View more"
        }
         
    }
    
    func initiateModel() {
        var countryCode = UserDefaults.getCountryCode
        if let details = self.countryModel?.countryISOCode {
            countryCode = details
        }
        viewModel?.getRangeGiftCards(countryCode: countryCode , language: "EN", planType: self.planType, operatorID: self.operatorID)
        viewModel?.searchRangeGiftCard.bind(listener: { (val) in
            self.filteredData = val
            if val.isEmpty == false{
                self.currentValue = Double(self.filteredData.first?.retailAmount?.min ?? 0.0)
                self.currencySymbol = self.filteredData.first?.currencySymbol ?? ""
                self.displayCurreny.text = self.currencySymbol
                self.planAmount.text = String(format: "%.2f", self.currentValue)
                self.boxWidthConstant.constant = CGFloat((self.planAmount.text?.count ?? 1) * 10)
                guard let minRange = self.filteredData.first?.retailAmount?.min else {return}
                guard let maxRange = self.filteredData.first?.retailAmount?.max else {return}
                self.showRangeText.text = "(\(self.currencySymbol + String(format: "%.2f", minRange)) to \(self.currencySymbol + String(format: "%.2f", maxRange)))"
                self.showDescription()
            }
        })
    }
    
    @IBAction func minusPlan(_ sender: Any) {
        if Double(filteredData.first?.retailAmount?.min ?? 0.0) < (currentValue - 1) {
            self.currentValue = currentValue - 1
            self.planAmount.text = String(format: "%.2f", self.currentValue)
        }else{
            self.currentValue = Double(filteredData.first?.retailAmount?.min ?? 0.0)
            self.planAmount.text = String(format: "%.2f", self.currentValue)
        }
        self.boxWidthConstant.constant = CGFloat((self.planAmount.text?.count ?? 1) * 10)
    }
    
    
    @IBAction func plusPlan(_ sender: Any) {
        if (filteredData.first?.retailAmount?.max ?? 0) > currentValue + 1{
            self.currentValue = currentValue + 1
            self.planAmount.text = String(format: "%.2f", self.currentValue)
        }else{
            self.currentValue = Double(filteredData.first?.retailAmount?.max ?? 0.0)
            self.planAmount.text = String(format: "%.2f", self.currentValue)
        }
        self.boxWidthConstant.constant = CGFloat((self.planAmount.text?.count ?? 1) * 10)
    }
    
    
    
    
    @IBAction func reviewRangePlan(_ sender: Any) {
        
        if self.currentValue <= (filteredData.first?.retailAmount?.max ?? 0) && self.currentValue >= (filteredData.first?.retailAmount?.min ?? 0){
        DispatchQueue.main.async {
            if let selectedCountry = self.countryModel{
            if let selectedPlan = self.viewModel?.searchRangeGiftCard.value.first{
                self.callSuccessPopup(planTypeID: 2, selectedRangePlan: selectedPlan, selectedCountry: selectedCountry)
            }}
            }
        }else{
            self.showAlert(withTitle: "Alert", message: "Please Enter Valid Amount!")
        }
        
    }
    func setupWalletBal(walletBal: Double){
        var model = UserDefaults.getUserData
        model?.walletAmount = walletBal
        if model != nil{
            UserDefaults.setUserData(data: model!)
        }
    }
    
    func callSuccessPopup(planTypeID: Int, selectedRangePlan : RangeGiftCardResponse, selectedCountry: SearchCountryModel){
    let viewController: ReviewRangeCardVC = ReviewRangeCardVC()
    viewController.delegate = self
    viewController.planType = planTypeID
    viewController.selectedRangePlan = selectedRangePlan
    viewController.retailAmount = self.currentValue
    viewController.selectedRangePlan = selectedRangePlan
    viewController.countryModel = selectedCountry
    viewController.modalPresentationStyle = .overFullScreen
    self.navigationController?.present(viewController, animated: true)
    }
//    {
//        let object = ReviewRangeCardVC.initialization()
//        object.showAlert(usingModel: planTypeID, selectedRangePlan: selectedRangePlan, currentAmount: self.currentValue, selectedCountry: selectedCountry) { (status, val) in
//            if status == true, let data = val{
//                self.setupWalletBal(walletBal: val?.walletAmount ?? 0.0)
//                self.successVoucher(denominationVal: self.currentValue, confirmObj: data, giftCardName: selectedRangePlan.operatorName ?? "")
//            }
//            else{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                    if let topController = UIApplication.topViewController() {
//                        topController.navigationController?.popViewController(animated: false)
//                    }
//                })
//            }}
//    }
    
    
    func successVoucher(denominationVal: Double, confirmObj: ConfirmIntrResponseObj, giftCardName: String){
        let viewController: SuccessGiftCardVC = SuccessGiftCardVC()
        viewController.denominationAmount = denominationVal
        viewController.countryName = self.countryModel?.countryName ?? ""
        viewController.countryCode = self.countryModel?.countryISOCode ?? ""
        viewController.GiftCardName = giftCardName
        viewController.externalId = confirmObj.externalID ?? ""
        viewController.processStatusID = confirmObj.processStatusID ?? 0
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension RangeCardVC: BackTOGiftCardDelegate {
    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
        if dismiss, let data = result{
            self.setupWalletBal(walletBal: data.walletAmount ?? 0.0)
            if let selectedPlan = self.viewModel?.searchRangeGiftCard.value.first{
            self.successVoucher(denominationVal: self.currentValue, confirmObj: data, giftCardName: selectedPlan.operatorName ?? "")
            }}
    }}



extension RangeCardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count > 0 && updatedText.count < 7
            {
            let countdots = (textField.text?.components(separatedBy: ".").count ?? 0) - 1
                if countdots > 0 && string == "."
                {
                    return false
                }else{
                    self.currentValue = Double(updatedText) ?? 0.0
                    self.boxWidthConstant.constant = CGFloat((updatedText.count) * 10)
                }
            }}
        
        
        return true
    }
}
