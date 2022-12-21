//
//  TransactionHistoryVC.swift
//  Altienco
//
//  Created by Ashish on 03/10/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import DropDown

class TransactionHistoryVC: UIViewController {
    
    var viewModel: TransactionHistoryViewModel?
    var dropDownModel: DropDownViewModel?
    var dropDownResponce = [DropDownResponseObj]()
    var historyResponce = [HistoryResponseObj]()
    let dropDownStatus = DropDown()
    var header1 = "My"
    var header2 = "Transaction"
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
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var firstHeader: UILabel!
    @IBOutlet weak var lastHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoading = true
        self.dropDownStatus.direction = .bottom
        if self.header1 != "" && self.header2 != ""{
            self.firstHeader.text = header1
            self.lastHeader.text = header2
        }
        dropDownModel = DropDownViewModel()
        viewModel = TransactionHistoryViewModel()
        historyTable.tableFooterView = UIView()
        self.historyTable.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        DispatchQueue.main.async {
            self.callHistoryData()
            self.getDropDownData()
        }
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
                self?.historyResponce = history ?? []
                self?.historyTable.reloadData()
            }
            }})
    }
    
    func callHistoryData() {
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID, pageNum: self.pageNum, pageSize: self.pageSize, langCode: "en", transactionTypeId: self.transactionTypeId)
        viewModel?.getTransactionHistory(model: model, complition: { (history, status) in
            DispatchQueue.main.async { [weak self] in
            self?.isLoading = status
            if status == true{
                self?.historyResponce.append(contentsOf: history ?? [])
                self?.historyTable.reloadData()
            }
                if history?.isEmpty == true{
                    self?.isLoading = false
                }
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
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
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
    

extension TransactionHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.historyResponce.count == 0 {
                self.historyTable.setEmptyMessage("No records found!")
            } else {
                self.historyTable.restore()
            }
        return self.historyResponce.count
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = (self.historyResponce.count )
        if indexPath.row == lastData - 10, isLoading {
            self.pageNum += 1
            self.callHistoryData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.historyResponce[indexPath.row]
        if model.transactionTypeID == 4 {
            let viewController: SuccessGiftCardVC = SuccessGiftCardVC()
            viewController.isFromHistory = true
            viewController.denominationAmount = model.amount ?? 0.0
            viewController.countryName = model.countryCode ?? ""
            viewController.countryCode = model.countryCode ?? ""
            viewController.GiftCardName = model.operatorName ?? ""
            viewController.externalId = model.externalId ?? ""
            viewController.processStatusID = model.processStatusId ?? 0
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        else if model.transactionTypeID == 3 {
            let viewController: IntrSuccessVC = IntrSuccessVC()
            viewController.isFromHistory = true
            viewController.processStatusID = model.processStatusId ?? 0
            viewController.externalId = model.externalId ?? "0"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
         let model = self.historyResponce[indexPath.row]
        if model.processStatusId != 3{
            cell.orderStatus.textColor = appColor.buttonGreenColor
        }
        else {
            cell.orderStatus.textColor = appColor.buttonRedColor
        }
        
            cell.orderStatus.text = model.transactionMessage
            cell.orderNumber.text = "\(lngConst.orderNo): " + (model.orderNumber ?? "")
            cell.rechargeType.text = model.transactionType
            if let amount = model.amount{
            cell.amount.text = (model.currency ?? "") + "\(amount)"
            }
//            if model.transactionTypeID == 2 || model.transactionTypeID == 5 {
        if model.transactionTypeID == 2  {

                cell.repeatContainer.isHidden = false
            }
            else{
                cell.repeatContainer.isHidden = true
            }
            cell.repeatRecharge.tag = indexPath.row
            cell.repeatRecharge.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
            if let time = model.transactionDate{
                cell.date.text = time.convertToDisplayFormat()}
        return cell
        }

    
    
    func successVoucher(mPin: String, denominationValue : String, walletBalance: Double, msgToShare: String, voucherID: Int){
        let viewController: SuccessRechargeVC = SuccessRechargeVC()
        viewController.denominationValue = denominationValue
        
        viewController.mPin = mPin
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    @objc func callSuccessPopup(sender: UIButton){
        var operatorTitle, currency, planName: String
        var denomination, operatorID: Int
        if sender.tag >= 0 {
        let model = self.historyResponce[sender.tag]
            operatorTitle = model.operatorName ?? ""
            planName = model.planName ?? ""
            currency = model.currency ?? ""
            denomination = Int(model.amount ?? 0.0)
            operatorID = model.operatorID ?? 0
            let viewController: ReviewPopupVC = ReviewPopupVC()
            viewController.delegate = self
            viewController.denomination = denomination
            viewController.currency = currency
            viewController.operatorTitle = operatorTitle
            viewController.operatorID = operatorID
            viewController.isEdit = false
            viewController.planName = planName
            viewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(viewController, animated: true)
        }
    }
    
}

extension TransactionHistoryVC: BackToUKRechargeDelegate {
    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
        if status, let val = result{
            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
        }
        }
}
