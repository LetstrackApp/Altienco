//
//  OperatorListVC.swift
//  LMRider
//
//  Created by Ashish on 09/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
//import CoreAudio

class OperatorListVC: UIViewController {
    var voucherHistory: VoucherHistoryViewModel?
    var viewModel : OperatorListViewModel?
    var operatorList : [OperatorListResponseObj] = []
    var pageNum = 1
    var pageSize = 20
    
    // voucher history view
    
    @IBOutlet weak var emptyMsg: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var opratorLogo: UIImageView!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var voucherHistoryContainer: UIView!
    
    //
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
    @IBOutlet weak var walletBalance: UILabel!{
        didSet{
            walletBalance.font = UIFont.SF_Bold(30.0)
            walletBalance.textColor = appColor.blackText
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
    @IBOutlet weak var operatorView: UIView!{
        didSet{
            self.operatorView.backgroundColor = appColor.lightGrayBack
            self.operatorView.layer.shadowOpacity = 1
            self.operatorView.layer.cornerRadius = 6.0
            self.operatorView.clipsToBounds=true
            
        }
    }
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var repeatContainer: UIView!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.addButton.setupNextButton(title: lngConst.add)
            }
        }
    }
    @IBOutlet weak var lastVoucherView: UIView!{
        didSet{
            self.lastVoucherView.layer.cornerRadius = 6.0
            self.lastVoucherView.layer.borderWidth = 1.0
            self.lastVoucherView.layer.borderColor = appColor.lightGrayBack.cgColor
            self.lastVoucherView.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var operatorCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voucherHistory = VoucherHistoryViewModel()
        viewModel = OperatorListViewModel()
        self.operatorCollection.register(UINib(nibName: "GiftCardCell", bundle:nil), forCellWithReuseIdentifier: "GiftCardCell")
        self.initiateModel()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
        self.callHistoryData()
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
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
            self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    @IBAction func showWallet(_ sender: Any)
    {
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func initiateModel() {
        var countryCode = CountryCode.UK.countryID
        (UserDefaults.getUserData?.countryCode == CountryCode.UK.ISOcode) || (UserDefaults.getUserData?.countryCode == CountryCode.UK.ISOcode2) ? (countryCode = CountryCode.UK.countryID) : (countryCode = CountryCode.IN.countryID)
        viewModel?.getOperator(countryID: countryCode ?? 102, transactionTypeId: TransactionTypeId.PhoneRecharge.rawValue, langCode: "en") { (operatorList, status, msg) in
            DispatchQueue.main.async { [weak self] in
                if status == true && msg == "", let operatorlist = operatorList{
                    self?.operatorList = operatorlist
                }else{
                    self?.showAlert(withTitle: "Alert", message: msg)
                }
                self?.operatorList.count ?? 0 > 0 ? (self?.emptyMsg.isHidden = true) : (self?.emptyMsg.isHidden = false)
                self?.operatorCollection.reloadData()
            }
            
            
        }
        
    }
    
    func callHistoryData() {
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = VoucherHistoryRequestObj.init(customerId: "\(customerID)", isRequiredAll: false, langCode: "en", operatorId: 0, pinBankUsedStatus: 0, pageNum: self.pageNum, pageSize: self.pageSize, transactionTypeId: 1)
            voucherHistory?.getHistory(model: model)
            voucherHistory?.historyList.bind(listener: { (data) in
                if data.isEmpty == false{
                    DispatchQueue.main.async {
                        self.initializeHistoryView()
                        self.voucherHistoryContainer.isHidden = false
                    }}
                else{
                    self.voucherHistoryContainer.isHidden = true
                }
            })
        }
    }
    
    func initializeHistoryView(){
        if voucherHistory?.historyList.value.count ?? 0 > 0, let model = voucherHistory?.historyList.value[0]{
            
            if let newString = model.imageURL{
                self.opratorLogo.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "ic_operatorThumbnail"))
            }
            else{
                self.opratorLogo.image = UIImage(named: "ic_operatorThumbnail")
            }
            if let amount = model.voucherAmount{
                self.amount.text = (UserDefaults.getUserData?.currencySymbol ?? "") + "\(amount)"
            }
            if model.transactionTypeId == 2{
                self.repeatContainer.isHidden = false
            }
            else{
                self.repeatContainer.isHidden = true
            }
            if let time = model.transactionDate{
                self.dateTime.text = time.convertToDisplayFormat()}
        }
    }
    
    @IBAction func walletView(_ sender: Any) {
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func redirectHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func repeatRecharge(_ sender: Any) {
        var operatorTitle, currency, planName: String
        var denomination, operatorID: Int
        if self.voucherHistory?.historyList.value.count ?? 0 > 0{
            let model = self.voucherHistory?.historyList.value[0]
            operatorTitle = model?.operatorName ?? ""
            planName = model?.planName ?? ""
            currency = model?.currency ?? ""
            denomination = model?.voucherAmount ?? 0
            operatorID = model?.operatorID ?? 0
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
    func callOperatorPlans(operatorID: Int, imageURL: String, OperatorName: String){
        let viewController: OperatorPlanVC = OperatorPlanVC(OperatorID: operatorID,
                                                            OperatorName: OperatorName,
                                                            imageUrl: imageURL)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OperatorListVC: BackToUKRechargeDelegate {
    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
        if status, let val = result{
            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
        }
    }
}


extension OperatorListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.operatorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCell", for: indexPath) as! GiftCardCell
        if let image = self.operatorList[indexPath.row].imageURL {
            var imageUrl = image
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.operatorLogo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "ic_operatorLogo"))
        }
        else{
            cell.operatorLogo.image = UIImage(named: "ic_operatorLogo")
        }
        cell.operatorName.text = self.operatorList[indexPath.row].operatorName
        cell.showDenomination.isHidden = true
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == operatorCollection{
            DispatchQueue.main.async {
                if indexPath.row < self.operatorList.count {
                    let operatorValue = self.operatorList[indexPath.row]
                    self.callOperatorPlans(operatorID: operatorValue.operatorID ?? 0,
                                           imageURL: operatorValue.imageURL ?? "",
                                           OperatorName: operatorValue.operatorName ?? "")
                    
                }
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2 + 15)
    }
    
    
}
