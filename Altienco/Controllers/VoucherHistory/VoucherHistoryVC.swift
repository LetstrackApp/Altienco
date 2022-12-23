//
//  VoucherHistoryVC.swift
//  Altienco
//
//  Created by Ashish on 09/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class VoucherHistoryVC: UIViewController {
    
    var viewModel: VoucherHistoryViewModel?
    var pageNum = 1
    var pageSize = 20
    var transactionTypeId = 0
    var isLoading = false
    var SelectedIndex = -1
    
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
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var voucherHistoryTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoading = true
        viewModel = VoucherHistoryViewModel()
        voucherHistoryTable.tableFooterView = UIView()
        self.voucherHistoryTable.register(UINib(nibName: "VoucherCell", bundle: nil), forCellReuseIdentifier: "VoucherCell")
        
    }
    
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.callHistoryData()
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
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = VoucherHistoryRequestObj.init(customerId: "\(customerID)", isRequiredAll: true, langCode: "en", operatorId: 0, pinBankUsedStatus: 2, pageNum: self.pageNum, pageSize: self.pageSize, transactionTypeId: 0)
        viewModel?.getHistory(model: model)
        viewModel?.historyList.bind(listener: { (data) in
            if data.isEmpty == false{
            DispatchQueue.main.async {
                self.voucherHistoryTable.reloadData()
                self.isLoading = false
            }}
        })
        }
    }
    
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
    }
    
}


extension VoucherHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel?.historyList.value.count == 0 {
                self.voucherHistoryTable.setEmptyMessage("No records found!")
            } else {
                self.voucherHistoryTable.restore()
            }
        return self.viewModel?.historyList.value.count ?? 0
    }

    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastData = (self.viewModel?.historyList.value.count ?? 0) - 1
        if !isLoading && indexPath.row == pageSize - lastData {
            self.pageNum += 1
            self.loadMoreData()
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath) as! VoucherCell
        if let model = self.viewModel?.historyList.value[indexPath.row]{
//             (model.transactionStatus?.capitalized != "Success".capitalized) ?
//            (cell.orderStatus.textColor = appColor.buttonRedColor) : (cell.orderStatus.textColor = appColor.buttonGreenColor)
            if model.isUsed == false{
                cell.voucherStatus.text = "AVILABLE".uppercased()
                cell.voucherStatus.textColor = appColor.buttonGreenColor
            }
            else{
                cell.voucherStatus.text = "USED".uppercased()
                cell.voucherStatus.textColor = appColor.buttonRedColor
            }
            if let newString = model.imageURL{
                
                cell.operatorImage.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "ic_operatorThumbnail"))
            }
            else{
                cell.operatorImage.image = UIImage(named: "ic_operatorThumbnail")
            }
            cell.orderNumber.text = "\(lngConst.orderNo): " + (model.orderNumber ?? "")
            if let amount = model.voucherAmount{
                cell.amount.text = (UserDefaults.getUserData?.currencySymbol ?? "") + "\(amount)"
            }
            if let time = model.transactionDate{
                cell.date.text = time.convertToDisplayFormat()}
        }
        return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.SelectedIndex = indexPath.row
        self.showVoucher()
    }

    
    @objc func showVoucher() {
        if self.SelectedIndex < (self.viewModel?.historyList.value.count ?? 0) && self.SelectedIndex != -1{
            
            DispatchQueue.main.async {
                guard let model = self.viewModel?.historyList.value[self.SelectedIndex] else {return}
                if model.transactionTypeId == TransactionTypeId.PhoneRecharge.rawValue{
                self.successVoucher(mPin: model.mPIN ?? "",
                                    denominationValue: "\(model.voucherAmount ?? 0)",
                                    walletBalance: 0.0, msgToShare: model.msgToShare ?? "",
                                    voucherID: model.voucherId ?? 0,
                                    isUsed: model.isUsed,
                                    orderNumber: model.orderNumber)
                }
                else{
                    self.successCallingCard(mPin: model.mPIN ?? "",
                                            denominationValue: "\(model.voucherAmount ?? 0)",
                                            walletBalance: 0.0,
                                            msgToShare: model.msgToShare ?? "",
                                            voucherID: model.voucherId ?? 0,
                                            isUsed: model.isUsed,
                                            orderNumber: model.orderNumber)
                }
            }
        }
    }
    func successVoucher(mPin: String,
                        denominationValue : String,
                        walletBalance: Double,
                        msgToShare: String,
                        voucherID: Int,
                        isUsed: Bool,
                        orderNumber:String?) {
        let viewController: SuccessRechargeVC = SuccessRechargeVC()
        viewController.denominationValue = denominationValue
        viewController.mPin = mPin
        viewController.isUsed = isUsed
        viewController.isHideVoucherButton = true
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        viewController.orderNumber = orderNumber
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    func successCallingCard(mPin: String,
                            denominationValue : String,
                            walletBalance: Double,
                            msgToShare: String, voucherID: Int,
                            isUsed: Bool,
                            orderNumber:String?){
        let viewController: SuccessCallinCardVC = SuccessCallinCardVC()
        viewController.denominationValue = denominationValue
        viewController.mPin = mPin
        viewController.isUsed = isUsed
        viewController.isHideVoucherButton = true
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        viewController.orderNumber = orderNumber
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
