//
//  DenominationVC.swift
//  Altienco
//
//  Created by Ashish on 21/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SkeletonView

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
            viewContainer.roundFromTop(radius: 10)
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
            self.addButton.setupNextButton(title: lngConst.add_Balance,space: 1.6)
            self.addButton.setTitle(lngConst.add_Balance, for: .normal)
        }
    }
    
    @IBOutlet weak var tableContainer: UIView! {
        didSet {
            tableContainer.roundFromBottom(radius: 10)
        }
    }
    @IBOutlet weak var topUpTitle: PaddingLabel!{
        didSet {
            topUpTitle.bottomInset = 3
        }
    }
    
    
    @IBOutlet weak var denominationTable: UITableView!{
        didSet{
            
            denominationTable.register(UINib(nibName: "OperatorInfoCell", bundle: nil), forCellReuseIdentifier: "OperatorInfoCell")
            denominationTable.register(UINib(nibName: "DenoCell", bundle: nil), forCellReuseIdentifier: "DenoCell")
            denominationTable.delegate = self
            denominationTable.dataSource = self
            denominationTable.rowHeight = UITableView.automaticDimension
            denominationTable.sectionHeaderHeight = UITableView.automaticDimension
            denominationTable.sectionFooterHeight = UITableView.automaticDimension
            denominationTable.estimatedRowHeight = 200
            denominationTable.estimatedSectionFooterHeight = 1
            denominationTable.estimatedSectionHeaderHeight = 182
            denominationTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            denominationTable.tableFooterView = UIView.init(frame: .zero)
            denominationTable.tableHeaderView = UIView.init(frame: .zero)
            denominationTable.isSkeletonable = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.denominationTable.isHidden = true
        viewModel = IntrOperatorPlanViewModel()
        
        self.setupDefault()
        // Do any additional setup after loading the view.
        onLanguageChange()
    }
    
    
    
    func onLanguageChange(){
        self.topUpTitle.changeColorAndFont(mainString: lngConst.topUpPlans.capitalized,
                                           stringToColor: lngConst.plans.capitalized,
                                           color: UIColor.init(0xb24a96),
                                           font: UIFont.SF_Medium(18))
        
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
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
        //        self.countryName.text = countryModel?.countryName
        //        if let operatorName = selectedOperator?.operatorName{
        //            self.operatorName.text = operatorName
        //        }
        if let countryCode = countryModel?.countryISOCode,
           let mobileCode = countryModel?.mobileCode,
           let operatorId = selectedOperator?.providerAPIID {
            self.searchOperator(operatorId: operatorId,
                                mobileNumber: mobileNumber ?? "",
                                countryCode: countryCode,
                                mobileCode: mobileCode)}
    }
    
    
    func searchOperator(operatorId: Int,
                        mobileNumber: String,
                        countryCode: String,
                        mobileCode: String) {
        
        denominationTable.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))
        //        if let customerID = UserDefaults.getUserData?.customerID {
        let model = IntroperatorPlanRequestObj.init(operatorID: operatorId,
                                                    countryCode: countryCode,
                                                    mobileCode: mobileCode,
                                                    mobileNumber: mobileNumber,
                                                    langCode: "eng")
        viewModel?.getOperator(model: model) { [weak self] (lastRecharge) in
            DispatchQueue.main.async {
                self?.denominationTable.stopSkeletonAnimation()
                self?.denominationTable.hideSkeleton()
                if let operatorList = lastRecharge {
                    self?.operatorList = operatorList
                }
                self?.denominationTable.reloadData()
            }
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
//            if let currentOperator = self.selectedOperator{
//                let viewController: ReviewIntrVC = ReviewIntrVC()
//                viewController.delegate = self
//                viewController.mobileNumberValue = mobileNumber
//                viewController.countryModel = self.countryModel
//                viewController.selectedOperator = currentOperator
//                viewController.planHistoryResponse = self.planHistoryResponse
//                viewController.modalPresentationStyle = .overFullScreen
//                self.navigationController?.present(viewController, animated: true)
//            }
            
            ReviewIntrVC.initialization().showAlert(usingModel: planHistoryResponse,
                                                    countryModel: self.countryModel,
                                                    selectedOperator: self.selectedOperator,
                                                    mobileNumberValue: mobileNumber?.trimWhiteSpace) { result, isSuccess in
                DispatchQueue.main.async {
                    if isSuccess, let data = result{
                        self.successVoucher(walletBalance: data.walletAmount ?? 0.0, currencySymbol: data.currency ?? "",processStatusID: data.processStatusID ?? 0, externalId: data.externalID ?? "0")
                    }
                }

            }
            
        }}
    
    
}
//extension DenominationVC: BackTOGiftCardDelegate {
//    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
//        if dismiss, let data = result{
//            self.successVoucher(walletBalance: data.walletAmount ?? 0.0, currencySymbol: data.currency ?? "",processStatusID: data.processStatusID ?? 0, externalId: data.externalID ?? "0")
//        }
//    }}


extension DenominationVC: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DenoCell"
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "OperatorInfoCell") as! OperatorInfoCell
        headerView.addSubview(headerCell)
        headerCell.setupCellData(mobile: mobileNumber,
                                 country: countryModel?.countryName,
                                 planOperator: selectedOperator?.operatorName)
        headerCell.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 182)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.operatorList.count
//        if section == 0 {
//            return 1
//        }
//        else {
//            return self.operatorList.count
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 182
        }
        else {
            return 0.1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.section == 0 {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorInfoCell", for: indexPath) as! OperatorInfoCell
        //
        //
        //            cell.setupCellData(mobile: mobileNumber,
        //                               country: countryModel?.countryName,
        //                               planOperator: selectedOperator?.operatorName)
        //            return cell
        //
        //        }
        //        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DenoCell", for: indexPath) as! DenoCell
        let model = self.operatorList[indexPath.row]
        cell.setupUI(model: model)
        cell.selectPlan.tag = indexPath.row
        cell.selectPlan.addTarget(self, action: #selector(callSuccessPopup(sender:)), for: .touchUpInside)
        return cell
        
        //        }
    }
    
    
}
