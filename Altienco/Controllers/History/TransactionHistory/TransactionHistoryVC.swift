//
//  TransactionHistoryVC.swift
//  Altienco
//
//  Created by Ashish on 03/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import SkeletonView

class TransactionHistoryVC: FloatingPannelHelper {
    
    var viewModel: TransactionHistoryViewModel?
    var dropDownModel: DropDownViewModel?
    var dropDownResponce = [DropDownResponseObj]()
    let dropDownStatus = DropDown()
    var pageNum = 1
    var pageSize = 20
    var transactionTypeId = 0
    var isLoading = false
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var dropDownContainer: UIView!{
        didSet{
            self.dropDownContainer.layer.cornerRadius = 6.0
            self.dropDownContainer.clipsToBounds = true
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        }
    }
    @IBOutlet weak var userName: UILabel!
    
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
    @IBOutlet weak var historyTable: UITableView!{
        didSet {
            historyTable.rowHeight = UITableView.automaticDimension
            historyTable.sectionHeaderHeight = UITableView.automaticDimension
            historyTable.sectionFooterHeight = UITableView.automaticDimension
            historyTable.estimatedRowHeight = 113
            historyTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            historyTable.tableFooterView = UIView.init(frame: .zero)
            historyTable.tableHeaderView = UIView.init(frame: .zero)
            historyTable.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var firstHeader: UILabel!
    @IBOutlet weak var lastHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoading = true
        self.dropDownStatus.direction = .bottom
        dropDownModel = DropDownViewModel()
        viewModel = TransactionHistoryViewModel()
        historyTable.tableFooterView = UIView()
        self.historyTable.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        DispatchQueue.main.async {
            self.callHistoryData()
            self.getDropDownData()
        }
        onLanguageChange()
    }
    
    func onLanguageChange(){
        
        firstHeader.changeColorAndFont(mainString: lngConst.my_Transaction.capitalized,
                                       stringToColor: lngConst.transaction.capitalized,
                                       color: UIColor.init(0xb24a96),
                                       font: UIFont.SF_Medium(18))
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // Remove the 1-second delay if you want to load the data without waiting
                // Download more data here
                self.callHistoryData()
            }
        }
    }
    
    
    func getDropDownData() {
        
        let model = DropDownRequestModel.init(customerID: UserDefaults.getUserData?.customerID ?? 0, dropdownID: 2, langCode: "en")
        dropDownModel?.getDropDown(model: model)
        dropDownModel?.dropDownList.bind(listener: { (data) in
            self.isLoading = data.isEmpty
            if data.isEmpty == false{
                DispatchQueue.main.async {
                    self.dropDownResponce = data
                }}
        })
        
    }
    
    func refreshHistoryData() {
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID, pageNum: self.pageNum, pageSize: self.pageSize, langCode: "en", transactionTypeId: self.transactionTypeId)
        viewModel?.getTransactionHistory(model: model, complition: { (history, status) in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = status
                if status == true{
                    self?.viewModel?.historyList.value = history ?? []
                    self?.historyTable.reloadData()
                }
            }
        }
        )
    }
    
    func callHistoryData() {
        
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID,
                                           pageNum: self.pageNum,
                                           pageSize: self.pageSize,
                                           langCode: "en",
                                           transactionTypeId: self.transactionTypeId)
        if viewModel?.historyList.value.count == 0 {
            historyTable.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))

        }else {
            SVProgressHUD.show()
        }
       
        
        viewModel?.getTransactionHistory(model: model, complition: { (history, status) in
            DispatchQueue.main.async { [weak self] in
                self?.historyTable.stopSkeletonAnimation()
                self?.historyTable.hideSkeleton()
                self?.isLoading = status
                if status == true{
                    self?.viewModel?.historyList.value.append(contentsOf: history ?? [])
                  
                }
                if history?.isEmpty == true{
                    self?.isLoading = false
                }
                self?.historyTable.reloadData()
            }})
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupValue()
        self.showNotify()
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
    }
    
    
    
    @IBAction func notification(_ sender: Any) {
        setupAllNoti()
    }
    func showNotify(){
        if UserDefaults.isNotificationRead == "1"{
            self.notificationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notificationIcon.image = UIImage(named: "ic_notification")
        }
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        self.customizeDropDown()
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func customizeDropDown() {
        var statusName = [String]()
        for name in self.dropDownResponce {
            statusName.append(name.name ?? "")
        }
        self.dropDownStatus.dataSource = statusName ?? []
        self.dropDownStatus.direction = .bottom
        self.dropDownStatus.width = self.dropDownContainer.frame.size.width
        self.dropDownStatus.anchorView = self.dropDownContainer
        self.dropDownStatus.topOffset = CGPoint(x: 0, y:-(self.dropDownStatus.anchorView?.plainView.bounds.height)!)
        self.dropDownStatus.bottomOffset = CGPoint(x: 0, y:(self.dropDownStatus.anchorView?.plainView.bounds.height)!)
        self.dropDownStatus.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
        }
        self.dropDownStatus.selectionAction = { [weak self] (index, item) in
            debugPrint(index, item)
            self?.statusText.text = item
            self?.pageNum = 1
            self?.self.transactionTypeId = self?.dropDownResponce[index].id ?? 0
            self?.refreshHistoryData()
        }
        self.dropDownStatus.show()
    }
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
    }
    
}


extension TransactionHistoryVC: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HistoryCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel?.historyList.value.count ?? 0 == 0 {
            self.historyTable.setEmptyMessage("No records found!")
        } else {
            self.historyTable.restore()
        }
        return self.viewModel?.historyList.value.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = self.viewModel?.historyList.value.count  ?? 0
        if indexPath.row == lastData - 10, isLoading {
            self.pageNum += 1
            self.callHistoryData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.viewModel?.historyList.value[indexPath.row] {
        if model.transactionTypeID == 4 {
            let viewController: SuccessGiftCardVC = SuccessGiftCardVC()
            viewController.isFromHistory = true
            viewController.denominationAmount = model.amount ?? 0.0
            viewController.countryName = model.countryCode ?? ""
            viewController.countryCode = model.countryCode ?? ""
            viewController.GiftCardName = model.operatorName ?? ""
            viewController.externalId = model.externalId ?? ""
            viewController.processStatusID = model.processStatusId ?? 0
            viewController.orderNumber = model.orderNumber
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        else if model.transactionTypeID == 3 {
            let viewController: IntrSuccessVC = IntrSuccessVC()
            viewController.isFromHistory = true
            viewController.processStatusID = model.processStatusId ?? 0
            viewController.externalId = model.externalId ?? "0"
            viewController.orderNumber = model.orderNumber
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.model = self.viewModel?.historyList.value[indexPath.row]
        cell.repeatRecharge.tag = indexPath.row
        cell.repeatRecharge.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    
//    func successVoucher(mPin: String,
//                        denominationValue : String,
//                        walletBalance: Double,
//                        msgToShare: String,
//                        voucherID: Int,
//                        orderNumber:String){
//        let viewController: SuccessRechargeVC = SuccessRechargeVC()
//        viewController.denominationValue = denominationValue
//        viewController.mPin = mPin
//        viewController.walletBal = walletBalance
//        viewController.voucherID = voucherID
//        viewController.msgToShare = msgToShare
//        viewController.orderNumber = orderNumber
//        self.navigationController?.pushViewController(viewController, animated: true)
//        
//    }
    
    
    @objc func callSuccessPopup(sender: UIButton){
        
        var operatorTitle, currency, planName: String
        var denomination, operatorID: Int
        
        if sender.tag >= 0 {
            if  let model = self.viewModel?.historyList.value[sender.tag],
                let transactionTypeID = model.transactionTypeID,
                let txnid =  TransactionTypeId(rawValue: transactionTypeID) {
                operatorTitle = model.operatorName ?? ""
                planName = model.planName ?? ""
                currency = model.currency ?? ""
                denomination = Int(model.amount ?? 0.0)
                operatorID = model.operatorID ?? 0
                //            let viewController: ReviewPopupVC = ReviewPopupVC()
                //            viewController.delegate = self
                let reviewPopupModel = ReviewPopupModel.init(mobileNumber: nil,
                                                             operatorID: operatorID,
                                                             denomination: denomination,
                                                             operatorTitle: operatorTitle,
                                                             planName: planName,
                                                             currency: currency,
                                                             isEdit:false,
                                                             transactionTypeId: txnid.rawValue)
                ReviewPopupVC.initialization().showAlert(usingModel: reviewPopupModel) { result, resultThirdParty, status  in
                    DispatchQueue.main.async {
                        if status == true, let val = result{
                            
                        }
                    }
                }
            }
        }
    }
    
}

//extension TransactionHistoryVC: BackToUKRechargeDelegate {
//    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
//        if status, let val = result{
//            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
//        }
//        }
//}
