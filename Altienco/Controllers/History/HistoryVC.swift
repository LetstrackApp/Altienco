//
//  HistoryVC.swift
//  LMRider
//
//  Created by APPLE on 01/12/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import DropDown
class HistoryVC: UIViewController {
    
    var viewModel: HistoryViewModel?
    var header1 = "My"
    var header2 = "Order"
    var pageNum = 1
    var pageSize = 20
    var transactionTypeId = 0
    var isLoading = false
    
    @IBOutlet weak var userName: UILabel!
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
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var firstHeader: UILabel!
    @IBOutlet weak var lastHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoading = true
        if self.header1 != "" && self.header2 != ""{
            self.firstHeader.text = header1
            self.lastHeader.text = header2
        }
        viewModel = HistoryViewModel()
        historyTable.tableFooterView = UIView()
        self.historyTable.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        self.callHistoryData()
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    
    func callHistoryData() {
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID, pageNum: self.pageNum, pageSize: self.pageSize, langCode: "en", transactionTypeId: self.transactionTypeId)
        viewModel?.getHistory(model: model)
        viewModel?.historyList.bind(listener: { (data) in
            self.isLoading = data.isEmpty
            if data.isEmpty == false{
                DispatchQueue.main.async {
                    self.historyTable.reloadData()
                }}
        })
        
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
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
    }
    
}


extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel?.historyList.value.count == 0 {
            self.historyTable.setEmptyMessage("No records found!")
        } else {
            self.historyTable.restore()
        }
        return self.viewModel?.historyList.value.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = (self.viewModel?.historyList.value.count ?? 0)
        if indexPath.row == lastData - 10, isLoading {
            self.pageNum += 1
            self.callHistoryData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        if let model = self.viewModel?.historyList.value[indexPath.row]{
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
            if model.transactionTypeID == 2{
                cell.repeatContainer.isHidden = false
            }
            else{
                cell.repeatContainer.isHidden = true
            }
            cell.repeatRecharge.tag = indexPath.row
            cell.repeatRecharge.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
            if let time = model.transactionDate{
                cell.date.text = time.convertToDisplayFormat()}
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.viewModel?.historyList.value[indexPath.row]{
            if model.transactionTypeID == 4{
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
                
            }else if model.transactionTypeID == 3{
                let viewController: IntrSuccessVC = IntrSuccessVC()
                viewController.isFromHistory = true
                viewController.processStatusID = model.processStatusId ?? 0
                viewController.externalId = model.externalId ?? "0"
                viewController.orderNumber = model.orderNumber
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func successVoucher(mPin: String,
                        denominationValue : String,
                        walletBalance: Double,
                        msgToShare: String,
                        voucherID: Int,
                        orderNumber:String){
        let viewController: SuccessRechargeVC = SuccessRechargeVC()
        viewController.denominationValue = denominationValue
        viewController.mPin = mPin
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        viewController.orderNumber = orderNumber
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    @objc func callSuccessPopup(sender: UIButton){
        var operatorTitle, currency, planName: String
        var denomination, operatorID: Int
        if sender.tag >= 0{
            if let model = self.viewModel?.historyList.value[sender.tag]{
                operatorTitle = model.operatorName ?? ""
                planName = model.planName ?? ""
                currency = model.currency ?? ""
                denomination = Int(model.amount ?? 0.0)
                operatorID = model.operatorID ?? 0
                //                let viewController: ReviewPopupVC = ReviewPopupVC()
                //                viewController.delegate = self
                let reviewPopupModel = ReviewPopupModel.init(mobileNumber: nil,
                                                             operatorID: operatorID,
                                                             denomination: denomination,
                                                             operatorTitle: operatorTitle,
                                                             planName: planName,
                                                             currency: currency,
                                                             isEdit:false,
                                                             transactionTypeId: TransactionTypeId.PhoneRecharge.rawValue)
                ReviewPopupVC.initialization().showAlert(usingModel: reviewPopupModel) { result, status in
                    DispatchQueue.main.async {
                        if status == true, let val = result{
                            self.successVoucher(mPin: val.mPIN ?? "",
                                                denominationValue: "\(val.dinominationValue ?? 0)",
                                                walletBalance: val.walletAmount ?? 0.0,
                                                msgToShare: val.msgToShare ?? "",
                                                voucherID: val.voucherID ?? 0,
                                                orderNumber: "")
                        }
                    }
                }
                //                viewController.reviewPopupModel = model
                //                viewController.modalPresentationStyle = .overFullScreen
                //                self.navigationController?.present(viewController, animated: true)
                
            }
        }
    }
    
}

//extension HistoryVC: BackToUKRechargeDelegate {
//    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
//        if status, let val = result{
//            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
//        }
//        }
//}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.SF_Regular(16.0)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
