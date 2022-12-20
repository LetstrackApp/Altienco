//
//  WalletVC.swift
//  LMRider
//
//  Created by Ashish on 09/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {

    var historyResponce = [HistoryResponseObj]()
    var viewModel : TransactionHistoryViewModel?
    var pageNum = 1
    var pageSize = 20
    var transactionTypeId = 1
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var walletBalnace: UILabel!{
        didSet{
            walletBalnace.font = UIFont.SF_Bold(40)
            walletBalnace.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var walletText: UILabel!{
        didSet{
            walletText.font = UIFont.SFPro_Light(12.0)
            walletText.textColor = appColor.lightGrayText
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
        }
    }
    
    @IBOutlet weak var addBalance: UIButton!{
        didSet{
            DispatchQueue.main.async {
                
            }
        }
    }
    
    @IBOutlet weak var walletContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.walletContainer.layer.shadowPath = UIBezierPath(rect: self.walletContainer.bounds).cgPath
                self.walletContainer.layer.shadowRadius = 5
                self.walletContainer.layer.shadowOffset = .zero
                self.walletContainer.layer.shadowOpacity = 1
                self.walletContainer.layer.cornerRadius = 8.0
                self.walletContainer.clipsToBounds=true
            }
            self.walletContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var tableContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.tableContainer.layer.shadowPath = UIBezierPath(rect: self.tableContainer.bounds).cgPath
                self.tableContainer.layer.shadowRadius = 5
                self.tableContainer.layer.shadowOffset = .zero
                self.tableContainer.layer.shadowOpacity = 1
                self.tableContainer.layer.cornerRadius = 8.0
                self.tableContainer.clipsToBounds=true
            }
            self.tableContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var walletHistoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TransactionHistoryViewModel()
        self.addBalance.setupNextButton(title: lngConst.addBalance)
        self.walletHistoryTable.register(UINib(nibName: "walletTableCell", bundle: nil), forCellReuseIdentifier: "walletTableCell")
        self.walletHistoryTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func callHistoryData() {
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID, pageNum: self.pageNum, pageSize: self.pageSize, langCode: "en", transactionTypeId: self.transactionTypeId)
        viewModel?.getTransactionHistory(model: model, complition: { (history, status) in
            DispatchQueue.main.async { [weak self] in
//            self?.isLoading = status
            if status == true{
                self?.historyResponce = history ?? []
                self?.walletHistoryTable.reloadData()
            }
            }})
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
    
    @IBAction func homeButton(_ sender: Any) {
        
        
        self.navigationController?.popToRootViewController(animated: true)
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
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalnace.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func addBal(_ sender: Any) {
        let viewController: AddCardVC = AddCardVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func backVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (self.historyResponce.count == 0) ? (self.tableContainer.isHidden = true) : (self.tableContainer.isHidden = false)
        return self.historyResponce.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletTableCell", for: indexPath) as! walletTableCell
        if self.historyResponce.count > indexPath.row{
         let model = self.historyResponce[indexPath.row]
             (model.transactionStatus == false) ?
            (cell.orderStatus.textColor = appColor.buttonRedColor) : (cell.orderStatus.textColor = appColor.buttonGreenColor)
            cell.orderStatus.text = model.transactionMessage
            if let amount = model.amount{
            cell.amount.text = (model.currency ?? "") + "\(amount)"
            }
            cell.orderNumber.text = "Order Number: " + (model.orderNumber ?? "")
            if let time = model.transactionDate{
                cell.date.text = time.convertToDisplayFormat()}
        }
        return cell
        }


}

extension Date {
//2
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self).capitalized
    }
    func dateOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self).capitalized
    }
    func toTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self).capitalized
    }
}


extension String {
//1
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        //2022-09-06T05:06:26.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
//3
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
    func dateFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.dayOfWeek()
    }
    func dayFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.dateOfMonth()
    }
    func timeFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.toTime()
    }
    
    func convertGiftCardFormat() -> Date? {
        let dateFormatter = DateFormatter()
        //2022-09-06T05:06:26.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
//3
    func giftCardFormat() -> String {
        guard let date = self.convertGiftCardFormat() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
