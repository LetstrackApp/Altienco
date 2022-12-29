//
//  RecentTXNVC.swift
//  Altienco
//
//  Created by mac on 23/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SkeletonView
class RecentTXNVC: UIViewController {
    
    private var viewModel : TransactionHistoryViewModel?
    private var txnType : TransactionTypeId?
    
    var didSelectDone: ((GenerateVoucherResponseObj?,ConfirmingIntrPINBankVoucherModel?)->())?
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.tableFooterView = UIView()
            tableview.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
            tableview.delegate = self
            tableview.dataSource = self
            tableview.isSkeletonable = true
            tableview.rowHeight = UITableView.automaticDimension
            tableview.estimatedRowHeight = 200
            tableview.tableFooterView = UIView.init(frame: .zero)
            tableview.tableHeaderView = UIView.init(frame: .zero)

            
            
        }
    }
    
    
    convenience init(txnType : TransactionTypeId?) {
        self.init(nibName: xibName.recentTXNVC, bundle: .altiencoBundle)
        self.viewModel =  TransactionHistoryViewModel()
        self.txnType = txnType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))

        // Do any additional setup after loading the view.
    }
    
    func getRecentFiveTxn(completion:@escaping(Bool)->Void) {
        tableview.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))
        
        let model = HistoryRequestObj.init(customerId: UserDefaults.getUserData?.customerID,
                                           pageNum: 1,
                                           pageSize: 5,
                                           langCode: "en",
                                           transactionTypeId: txnType?.rawValue)
        
        viewModel?.getTransactionHistory(model: model) {  [weak self] txn, result in
            DispatchQueue.main.async {
                self?.tableview.stopSkeletonAnimation()
                self?.tableview.hideSkeleton()
                self?.tableview.reloadData()
                completion((self?.viewModel?.historyList.value.count  ?? 0) > 0 ? true : false)
            }
        }
    }
    
    
    
    
}

extension RecentTXNVC: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HistoryCell"
    }
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.historyList.value.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.model = self.viewModel?.historyList.value[indexPath.row]
        cell.repeatRecharge.tag = indexPath.row
        cell.repeatRecharge.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func callSuccessPopup(sender: UIButton){
        
        var operatorTitle, currency, planName: String
        var denomination, operatorID: Int
        
        if sender.tag >= 0 {
            if let model = self.viewModel?.historyList.value[sender.tag] {
                if let transactionTypeID = model.transactionTypeID,
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
                    ReviewPopupVC.initialization().showAlert(usingModel: reviewPopupModel) { result,resultThirdParty, status in
                        DispatchQueue.main.async {
                            if status == true, let val = result{
                                self.didSelectDone?(val,resultThirdParty)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
