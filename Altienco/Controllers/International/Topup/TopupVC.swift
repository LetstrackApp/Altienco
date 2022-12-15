//
//  TopupVC.swift
//  Altienco
//
//  Created by Ashish on 20/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import DropDown




class TopupVC: UIViewController, searchDelegate, UITextFieldDelegate {
    
    
    var intrOperator: IntrOperatorViewModel?
    var countryModel : SearchCountryModel? = nil
    var selectedOperator : OperatorList? = nil
    var intrResponse: [OperatorList]? = []
    var planHistoryResponse: [LastRecharge]? = []
    let operatorDropDown = DropDown()
    
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
            self.profileImage.contentMode = .scaleToFill // OR .scaleAspectFill
            self.profileImage.layer.borderColor = appColor.lightGrayBack.cgColor
            self.profileImage.layer.borderWidth = 1.0
            self.profileImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var countryContainer: UIView!{
        didSet{
            self.countryContainer.layer.cornerRadius = 5.0
            self.countryContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var numberContainer: UIView!{
        didSet{
            self.numberContainer.layer.cornerRadius = 5.0
            self.numberContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var countryName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.searchButton.setupNextButton(title: "SEARCH")
            }
        }
    }
    @IBOutlet weak var operatorContainer: UIView!{
        didSet{
            self.operatorContainer.layer.cornerRadius = 5.0
            self.operatorContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var operatorName: UITextField!
    @IBOutlet weak var selectPlanContainer: UIView!
    @IBOutlet weak var selectPlanButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.selectPlanButton.layer.borderColor = appColor.purpleColor.cgColor
                self.selectPlanButton.layer.borderWidth = 1.0
                self.selectPlanButton.layer.cornerRadius = self.selectPlanButton.frame.size.height/2
                self.selectPlanButton.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var rechargeContainer: UIView!{
        didSet{
            self.rechargeContainer.layer.cornerRadius = 5.0
            self.rechargeContainer.layer.borderWidth = 1.0
            self.rechargeContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            self.rechargeContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var changePlan: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.changePlan.layer.borderColor = appColor.purpleColor.cgColor
                self.changePlan.layer.borderWidth = 1.0
                self.changePlan.layer.cornerRadius = 5.0
                self.changePlan.clipsToBounds=true
            }
        }
    }
    
    @IBOutlet weak var proceedButton: UIButton!{
        didSet{
            self.proceedButton.setupNextButton(title: lngConst.proceed)
        }
    }
    @IBOutlet weak var proceedContainer: UIView!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.setupNextButton(title: lngConst.add)
        }
    }
    @IBOutlet weak var walletBalnace: UILabel!{
        didSet{
            walletBalnace.font = UIFont.SF_Bold(30.0)
            walletBalnace.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var lastPriceContainer: UIView!{
        didSet{
            self.lastPriceContainer.layer.cornerRadius = 5.0
            self.lastPriceContainer.layer.borderWidth = 1.0
            self.lastPriceContainer.layer.borderColor = appColor.lightGrayBack.cgColor
            self.lastPriceContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var destinationPrice: UILabel!
    @IBOutlet weak var sourcePrice: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var validity: UILabel!
    @IBOutlet weak var planDescription: UILabel!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.operatorDropDown.direction = .bottom
        intrOperator = IntrOperatorViewModel()
        // Do any additional setup after loading the view.
        
        self.setupDefault()
    }

    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    @IBAction func showOperator(_ sender: Any) {
        self.customizeDropDown()
    }
    
    @IBAction func fetchOperator(_ sender: Any) {
        if countryModel == nil{
            Helper.showToast("Please select country!")
        }
        else if mobileNumber.text?.count ?? 0 > 9{
            
            if let countryid = self.countryModel?.countryID, let mobileCode = self.countryModel?.mobileCode{
            self.searchOperator(mobileNumber: self.mobileNumber.text ?? "", countryId: countryid, mobileCode: mobileCode)
            }}
        else{
            Helper.showToast("Please enter valid number!")
        }
    }
    
    func customizeDropDown() {
        var operatorName = [String]()
        for name in self.intrResponse ?? [] {
            operatorName.append(name.operatorName ?? "")
        }
        self.operatorDropDown.dataSource = operatorName ?? []
        self.operatorDropDown.direction = .top
        self.operatorDropDown.width = self.operatorContainer.frame.size.width
        self.operatorDropDown.anchorView = self.operatorContainer
        self.operatorDropDown.topOffset = CGPoint(x: 0, y:-(self.operatorDropDown.anchorView?.plainView.bounds.height)!)
        self.operatorDropDown.bottomOffset = CGPoint(x: 0, y:(self.operatorDropDown.anchorView?.plainView.bounds.height)!)
        self.operatorDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
        }
        self.operatorDropDown.selectionAction = { [weak self] (index, item) in
            debugPrint(index, item)
            self?.operatorName.text = item
            self?.selectedOperator = self?.intrResponse?[index]
        }
        self.operatorDropDown.show()
    }
    
    func setupDefault(){
        self.planHistoryResponse = nil
        self.intrResponse = nil
        self.selectedOperator = nil
        self.proceedContainer.isHidden = true
        self.selectPlanContainer.isHidden = true
        self.searchContainer.isHidden = false
        self.operatorContainer.isHidden = true
        self.rechargeContainer.isHidden = true
        
    }
    
    func updateOperator(){
        if self.intrResponse?.isEmpty == false{
            let operatorList = self.intrResponse?.filter {
                $0.isDefault == true
                }
            if let data = operatorList{
                self.operatorName.text = data.first?.operatorName
                self.selectedOperator = data.first
            }
            else{
                self.operatorName.text = ""
                self.selectedOperator = nil
                
            }
            self.rechargeContainer.isHidden = true
            self.proceedContainer.isHidden = true
            self.selectPlanContainer.isHidden = false
            self.searchContainer.isHidden = true
            self.operatorContainer.isHidden = false
            if planHistoryResponse?.isEmpty == true{
                self.proceedContainer.isHidden = true
                self.selectPlanContainer.isHidden = false
                self.searchContainer.isHidden = true
                self.operatorContainer.isHidden = false
                self.rechargeContainer.isHidden = true
            }
        }
    }
    
    func updateLastVoucher(){
        if planHistoryResponse?.isEmpty == false{
            self.rechargeContainer.isHidden = false
            self.selectPlanContainer.isHidden = true
            self.proceedContainer.isHidden = false
            if let model = planHistoryResponse?.first{
                self.destinationPrice.text = "\(model.destinationAmount ?? 0.0) " + (model.destinationUnit ?? "")
                self.sourcePrice.text = "(  \(model.retailAmount ?? 0.0) \(model.retailUnit ?? "NA")  )"
                self.data.text = model.data ?? "NA"
                if model.validityQuantity == -1{
                    self.validity.text = "Unlimited"
                }
                else{
                    self.validity.text = "\(model.validityQuantity ?? 0)" + (model.validityUnit ?? "NA")
                }
                self.planDescription.text = model.lastRechargeDescription
            }
        }
    }
    
    func searchOperator(mobileNumber: String, countryId: Int, mobileCode: String){
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = IntrOperatorRequestObj.init(countryID: countryId, mobileCode: mobileCode, mobileNumber: mobileNumber, customerID: customerID, langCode: "eng")
            intrOperator?.getOperator(model: model, complition: { (rechargeHistory, allOperatorList) in
            DispatchQueue.main.async { [weak self] in
                if allOperatorList?.isEmpty == false{
                    self?.intrResponse = allOperatorList
                    self?.updateOperator()
            }
                if rechargeHistory?.isEmpty == false{
                    self?.planHistoryResponse = rechargeHistory
                    self?.updateLastVoucher()
            }
            }
            })
        }
    }
    
    func updateSearchView(isUpdate: Bool, selectedCountry: SearchCountryModel?) {
        if isUpdate == true && selectedCountry != nil{
            countryModel = selectedCountry
            if let name = selectedCountry?.countryName{
                countryName.text = name
            }
            self.rechargeContainer.isHidden = true
            self.operatorContainer.isHidden = true
            self.selectPlanContainer.isHidden = true
            self.proceedContainer.isHidden = true
            self.searchContainer.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let newLength = (mobileNumber.text ?? "").count + string.count - range.length
        DispatchQueue.main.async {
            self.setupDefault()
        }
        
         if(textField == mobileNumber) {
             return newLength <= 12
         }
         return true
    }
    
    @IBAction func searchCountry(_ sender: Any) {
        let viewController: SearchCountryVC = SearchCountryVC()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalnace.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addBal(_ sender: Any) {
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func selectPlan(_ sender: Any) {
        if self.selectedOperator != nil{
            self.showPlanList()}
        else{
            Helper.showToast("Please Select Operator!")
        }
    }
    
    @IBAction func changePlan(_ sender: Any) {
        self.showPlanList()
    }
    
    @IBAction func rechargePlan(_ sender: Any) {
        self.callSuccessPopup()
    }
    
    func showPlanList(){
        let viewController: DenominationVC = DenominationVC()
        viewController.countryModel = self.countryModel
        viewController.selectedOperator = self.selectedOperator
        viewController.mobileNumber = self.mobileNumber.text!
//        viewController.planHistoryResponse = self.planHistoryResponse
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func successVoucher(walletBalance: Double, currencySymbol: String, processStatusID: Int, externalId: String){
            var model = UserDefaults.getUserData
        model?.walletAmount = walletBalance
            if model != nil{
                UserDefaults.setUserData(data: model!)
            }
        let viewController: IntrSuccessVC = IntrSuccessVC()
        viewController.countryModel = self.countryModel
        viewController.selectedOperator = self.selectedOperator
        viewController.planHistoryResponse = self.planHistoryResponse
        viewController.mobileNumber = self.mobileNumber.text!
        viewController.processStatusID = processStatusID
        viewController.externalId = externalId
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    func callSuccessPopup(){
        if let currentOperator = self.selectedOperator{
            let viewController: ReviewIntrVC = ReviewIntrVC()
            viewController.delegate = self
            viewController.countryModel = self.countryModel
            viewController.selectedOperator = currentOperator
            viewController.planHistoryResponse = self.planHistoryResponse
            viewController.mobileNumber = self.mobileNumber.text ?? ""
            viewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(viewController, animated: true)
        }
        
//        {
//        let object = ReviewIntrVC.initialization()
//        object.showAlert(usingModel: self.mobileNumber.text ?? "", countryModel: countryModel, selectedOperator: currentOperator, planHistoryResponse: self.planHistoryResponse ?? []) { (status, val) in
//            if status == true{
//                self.successVoucher(walletBalance: val?.walletAmount ?? 0.0, currencySymbol: val?.currency ?? "",processStatusID: val?.processStatusID ?? 0, externalId: val?.externalID ?? "0")
//            }
//            else{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                    if let topController = UIApplication.topViewController() {
//                        topController.navigationController?.popViewController(animated: false)
//                    }
//                })
//            }}}
    }
}


extension TopupVC: BackTOGiftCardDelegate {
    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
        if dismiss, let data = result{
           self.successVoucher(walletBalance: data.walletAmount ?? 0.0, currencySymbol: data.currency ?? "",processStatusID: data.processStatusID ?? 0, externalId: data.externalID ?? "0")
            }
        }}
