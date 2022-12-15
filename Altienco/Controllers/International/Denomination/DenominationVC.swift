//
//  DenominationVC.swift
//  Altienco
//
//  Created by Ashish on 21/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class DenominationVC: UIViewController {
    
    var viewModel : IntrOperatorPlanViewModel?
    var operatorList = [LastRecharge]()
    /// getting from previous view
    var countryModel : SearchCountryModel? = nil
    var planHistoryResponse = [LastRecharge]()
    var selectedOperator : OperatorList? = nil
    var mobileNumber : String?
    @IBOutlet weak var notificationIcon: UIImageView!
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
    @IBOutlet weak var topContainer: UIView!{
        didSet{
            self.topContainer.layer.cornerRadius = 6.0
            self.topContainer.clipsToBounds=true
        }
    }
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
    @IBOutlet weak var walletBalnace: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.addButton.setupNextButton(title: lngConst.add)
            }
        }
    }
    
    @IBOutlet weak var denominationTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.denominationTable.isHidden = true
        viewModel = IntrOperatorPlanViewModel()
        self.denominationTable.register(UINib(nibName: "DenoCell", bundle: nil), forCellReuseIdentifier: "DenoCell")
        
        self.setupDefault()
        // Do any additional setup after loading the view.
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
    @IBAction func showWallet(_ sender: Any)
        {
            let viewController: WalletPaymentVC = WalletPaymentVC()
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
    
    func setupDefault(){
        self.countryName.text = countryModel?.countryName
        if let operatorName = selectedOperator?.operatorName{
            self.operatorName.text = operatorName
        }
        if let countryCode = countryModel?.countryISOCode, let mobileCode = countryModel?.mobileCode, let operatorId = selectedOperator?.providerAPIID{
            self.searchOperator(operatorId: operatorId, mobileNumber: self.mobileNumber ?? "", countryCode: countryCode, mobileCode: mobileCode)}
    }
    
    
    func searchOperator(operatorId: Int, mobileNumber: String, countryCode: String, mobileCode: String){
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = IntroperatorPlanRequestObj.init(operatorID: operatorId, countryCode: countryCode, mobileCode: mobileCode, mobileNumber: mobileNumber, langCode: "eng")
            viewModel?.getOperator(model: model, complition: { (lastRecharge) in
                if lastRecharge?.isEmpty == false{
                    self.operatorList = lastRecharge ?? []
                    DispatchQueue.main.async {
                        self.denominationTable.reloadData()
                    }  }
                self.denominationTable.isHidden = false
            })
        }
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
        viewController.mobileNumber = self.mobileNumber ?? ""
        viewController.processStatusID = processStatusID
        viewController.externalId = externalId
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    @objc func callSuccessPopup(sender: UIButton){
        if sender.tag < self.operatorList.count{
            self.planHistoryResponse.removeAll()
            self.planHistoryResponse.append(operatorList[sender.tag])
        if let currentOperator = self.selectedOperator{
            let viewController: ReviewIntrVC = ReviewIntrVC()
            viewController.delegate = self
            viewController.countryModel = self.countryModel
            viewController.selectedOperator = currentOperator
            viewController.planHistoryResponse = self.planHistoryResponse
            viewController.mobileNumber = self.mobileNumber
            viewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(viewController, animated: true)
        }
//            {
//        let object = ReviewIntrVC.initialization()
//        object.showAlert(usingModel: self.mobileNumber ?? "", countryModel: countryModel, selectedOperator: currentOperator, planHistoryResponse: self.planHistoryResponse ?? []) { (status, val) in
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
        }}
    
    
}
extension DenominationVC: BackTOGiftCardDelegate {
    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
        if dismiss, let data = result{
           self.successVoucher(walletBalance: data.walletAmount ?? 0.0, currencySymbol: data.currency ?? "",processStatusID: data.processStatusID ?? 0, externalId: data.externalID ?? "0")
            }
        }}


extension DenominationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.operatorList.count == 0 {
            self.denominationTable.setEmptyMessage("No operator found!")
        } else {
            self.denominationTable.restore()
        }
        return self.operatorList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DenoCell", for: indexPath) as! DenoCell
        let model = self.operatorList[indexPath.row]
        cell.destinationPrice.text = "\(model.destinationAmount ?? 0.0)"
        cell.destinationUnit.text = model.destinationUnit
        cell.sourceAmount.text =  "  " + String(format: "%.2f", model.retailAmount ?? 0.0) +  "  \(model.retailUnit ?? "NA")  "
        cell.selectPlan.tag = indexPath.row
        cell.selectPlan.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
        cell.data.text = model.data
        if model.validityQuantity == -1{
            cell.validity.text = "Unlimited"
        }
        else{
            cell.validity.text = "\(model.validityQuantity ?? 0)" + (model.validityUnit ?? "NA")
        }
        cell.planDescription.text = model.lastRechargeDescription
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    
}
