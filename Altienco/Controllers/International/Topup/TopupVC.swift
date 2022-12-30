//
//  TopupVC.swift
//  Altienco
//
//  Created by Ashish on 20/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import DropDown

class TopupVC: FloatingPannelHelper, UITextFieldDelegate {
    
    
    var intrOperator: IntrOperatorViewModel?
    var countryModel : SearchCountryModel? = nil
    var selectedOperator : OperatorList? = nil
    var intrResponse: [OperatorList]? = []
    var planHistoryResponse: [LastRecharge]? = []
    let operatorDropDown = DropDown()
    
    @IBOutlet weak var topUpTitle: PaddingLabel!{
        didSet {
            topUpTitle.topInset = 6
            topUpTitle.bottomInset = 8
        }
    }
    @IBOutlet weak var headerView: UIStackView!{
        didSet{
            headerView.roundFromTop(radius: 10)
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.layer.cornerRadius = 10
            viewContainer.addShadow()
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
    @IBOutlet weak var mobileNumber: UITextField! {
        didSet {
            
            let imageview = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
            imageview.tintColor = UIColor.blue
            imageview.contentMode = .scaleAspectFit
            imageview.image = UIImage(named: "ic_contact_book")?.withInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2))
            imageview.addTarget(target: self, action: #selector(openContactBook(_:)))
            mobileNumber.rightView = imageview
            mobileNumber.rightViewMode = .always
            
        }
    }
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchButton: LoadingButton!{
        didSet{
            self.searchButton.setupNextButton(title: "SEARCH")
        }
    }
    @IBOutlet weak var operatorContainer: UIView!{
        didSet{
            self.operatorContainer.layer.cornerRadius = 5.0
            self.operatorContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
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
            self.addButton.setTitle(lngConst.add_Balance, for: .normal)

            self.addButton.setupNextButton(title: lngConst.add_Balance,space: 1.6)
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
        onLanguageChange()
    }
    
    func onLanguageChange(){
        self.topUpTitle.changeColorAndFont(mainString: lngConst.international_top_up.capitalized,
                                           stringToColor: lngConst.top_up.capitalized,
                                           color: UIColor.init(0xb24a96),
                                           font: UIFont.SF_Medium(18))
    }
    
    
    @IBAction func notification(_ sender: Any) {
        setupAllNoti()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupValue()
        self.updateProfilePic()
        self.showNotify()
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
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
        self.view.endEditing(true)
        
        self.customizeDropDown()
    }
    
    @IBAction func fetchOperator(_ sender: Any) {
        self.view.endEditing(true)
        
        if countryModel == nil{
            Helper.showToast("Please select country!")
        }
        
        else if mobileNumber.text?.count ?? 0 > 9 {
            
            if let countryid = self.countryModel?.countryID, let mobileCode = self.countryModel?.mobileCode{
                self.searchOperator(mobileNumber: self.mobileNumber.text ?? "", countryId: countryid, mobileCode: mobileCode)
            }}
        else{
            Helper.showToast("Please enter valid number!")
        }
    }
    
    @IBAction func openContactBook(_ sender : Any) {
        self.view.endEditing(true)
        if countryModel == nil {
            Helper.showToast(lngConst.selectCountery, delay: Helper.DELAY_LONG)
            countryContainer.shakeView()
            return
        }
        ContactPicker.shared.openConatactPiker(cotroller: self) { [weak self] (text) in
            if let contryCode = self?.countryModel?.mobileCode?.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: "") {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self?.setupDefault()
                    }
                    self?.mobileNumber.text = text.deletingPrefix(contryCode)
                }
                
            }
            
        }
    }
    
    func customizeDropDown() {
        var operatorName = [String]()
        for name in self.intrResponse ?? [] {
            operatorName.append(name.operatorName ?? "")
        }
        self.operatorDropDown.dataSource = operatorName
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
        if planHistoryResponse?.isEmpty == false {
            self.rechargeContainer.isHidden = false
            self.selectPlanContainer.isHidden = true
            self.proceedContainer.isHidden = false
            if let model = planHistoryResponse?.first {
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
    
    func searchOperator(mobileNumber: String,
                        countryId: Int, mobileCode: String){
        
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = IntrOperatorRequestObj.init(countryID: countryId,
                                                    mobileCode: mobileCode,
                                                    mobileNumber: mobileNumber,
                                                    customerID: customerID,
                                                    langCode: "eng")
            self.view.isUserInteractionEnabled = false
            self.searchButton.showLoading()
            intrOperator?.getOperator(model: model,
                                      complition: { (rechargeHistory, allOperatorList) in
                DispatchQueue.main.async { [weak self] in
                    self?.view.isUserInteractionEnabled = true
                    self?.searchButton.hideLoading()
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
    
    //countryName.setError()
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == mobileNumber) {
            if countryModel == nil {
                self.view.endEditing(true)
                countryContainer.shakeView()
                Helper.showToast(lngConst.selectCountery, delay: Helper.DELAY_LONG)
                return false
            }
        }
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
            self.showPlanList()
            
        }
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
    
    
    func successVoucher(walletBalance: Double,
                        currencySymbol: String,
                        processStatusID: Int,
                        externalId: String){
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
        if let currentOperator = self.selectedOperator {
            ReviewIntrVC.initialization().showAlert(usingModel: planHistoryResponse,
                                                    countryModel: self.countryModel,
                                                    selectedOperator: currentOperator,
                                                    mobileNumberValue: self.mobileNumber.text?.trimWhiteSpace) { result, isSuccess in
                DispatchQueue.main.async {
                    if isSuccess, let data = result{
                            self.successVoucher(walletBalance: data.walletAmount ?? 0.0,
                                                currencySymbol: data.currency ?? "",
                                                processStatusID: data.processStatusID ?? 0,
                                                externalId: data.externalID ?? "0")
                    }
                }

            }
           
//            let viewController: ReviewIntrVC = ReviewIntrVC()
//            viewController.delegate = self
//            viewController.countryModel = self.countryModel
//            viewController.selectedOperator = currentOperator
//            viewController.planHistoryResponse = self.planHistoryResponse
//            viewController.mobileNumberValue = self.mobileNumber.text ?? ""
//            viewController.modalPresentationStyle = .overFullScreen
//            self.navigationController?.present(viewController, animated: true)
        }
        

    }
}


//extension TopupVC: BackTOGiftCardDelegate {
//    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
//        if dismiss, let data = result{
//            self.successVoucher(walletBalance: data.walletAmount ?? 0.0, currencySymbol: data.currency ?? "",processStatusID: data.processStatusID ?? 0, externalId: data.externalID ?? "0")
//        }
//    }}

extension TopupVC: searchDelegate,UIScrollViewDelegate  {
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            headerView.addShadow()
        } else {
            headerView.deleteShadow()
        }
    }
}


