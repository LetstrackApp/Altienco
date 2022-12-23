//
//  AllCallingCardVC.swift
//  Altienco
//
//  Created by Deepak on 06/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SkeletonView
class AllCallingCardVC: FloatingPannelHelper {
    var voucherHistory: VoucherHistoryViewModel?
    var viewModel : OperatorListViewModel?
    var operatorList : [OperatorListResponseObj] = []
    var filteredOperatorList: [OperatorListResponseObj] = []
    var pageNum = 1
    var pageSize = 20
    
    @IBOutlet weak var last5Btn: LoadingButton!
    // voucher history view
    
    @IBOutlet weak var genetateVoucherTitle: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var opratorLogo: UIImageView!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var searchView: UISearchBar! {
        didSet {
            searchView.delegate = self
            searchView.backgroundImage = UIImage()
            searchView.searchTextField.font = UIFont.SF_Regular(16)
        }
    }
    @IBOutlet weak var voucherHistoryContainer: UIView!
    
    //
    @IBOutlet weak var emptyMsg: UILabel!
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
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var operatorCollection: UICollectionView! {
        didSet {
            operatorCollection.delegate = self
            operatorCollection.dataSource = self
            operatorCollection.isSkeletonable = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voucherHistory = VoucherHistoryViewModel()
        viewModel = OperatorListViewModel()
        self.operatorCollection.register(UINib(nibName: "GiftCardCell", bundle:nil), forCellWithReuseIdentifier: "GiftCardCell")
        self.initiateModel()
        onLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    
    func onLanguageChange(){
        self.addButton.setupNextButton(title: lngConst.add_Balance,space: 1.6)
        self.addButton.setTitle(lngConst.add_Balance, for: .normal)
        
        
        genetateVoucherTitle.changeColorAndFont(mainString: lngConst.generate_voucher.capitalized,
                                                stringToColor: lngConst.voucher.capitalized,
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
        //        self.callHistoryData()
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
        operatorCollection.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))
        
        viewModel?.getOperator(countryID: countryCode ?? 102,
                               transactionTypeId: TransactionTypeId.CallingCard.rawValue,
                               langCode: "en") { (operatorList, status, msg) in
            DispatchQueue.main.async { [weak self] in
                self?.operatorCollection.stopSkeletonAnimation()
                self?.operatorCollection.hideSkeleton()
                
                if status == true && msg == "", let operatorlist = operatorList{
                    self?.operatorList = operatorlist
                    self?.filteredOperatorList = operatorlist
                }else{
                    self?.showAlert(withTitle: "Alert", message: msg)
                }
                self?.operatorList.count ?? 0 > 0 ? (self?.emptyMsg.isHidden = true) : (self?.emptyMsg.isHidden = false)
                self?.operatorCollection.reloadData()
            }
            
        }
        
    }
    
    @IBAction func recentTXn(_ sender: Any) {
        self.view.endEditing(true)
        self.last5Btn.showLoading()
        self.view.isUserInteractionEnabled = false
        self.setupRecentTxn(txnTypeId: TransactionTypeId.CallingCard) { [weak self]_ in
            DispatchQueue.main.async {
                self?.last5Btn.hideLoading()
                self?.view.isUserInteractionEnabled = true
            }
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
            //            let viewController: ReviewPopupVC = ReviewPopupVC()
            //            viewController.delegate = self
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
        }
    }
    func callOperatorPlans(operatorID: Int, imageURL: String, OperatorName: String){
        let viewController: CallingCardPlanVC = CallingCardPlanVC()
        viewController.OperatorID = operatorID
        viewController.OperatorName = OperatorName
        viewController.imageUrl = imageURL
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//extension AllCallingCardVC: BackToUKRechargeDelegate {
//    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
//        if status, let val = result{
//            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
//        }
//    }
//}

extension AllCallingCardVC: SkeletonCollectionViewDataSource,
                            SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredOperatorList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GiftCardCell"
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCell", for: indexPath) as! GiftCardCell
        if let image = self.filteredOperatorList[indexPath.row].imageURL {
            var imageUrl = image
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.operatorLogo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "ic_operatorLogo"))
        }
        else{
            cell.operatorLogo.image = UIImage(named: "ic_operatorLogo")
        }
        cell.operatorName.text = self.filteredOperatorList[indexPath.row].operatorName
        cell.showDenomination.isHidden = true
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == operatorCollection{
            self.view.endEditing(true)
            
            DispatchQueue.main.async {
                if indexPath.row < self.filteredOperatorList.count {
                    let newString = self.filteredOperatorList[indexPath.row].imageURL ?? ""
                    self.callOperatorPlans(operatorID: self.filteredOperatorList[indexPath.row].operatorID ?? 0, imageURL: newString, OperatorName: self.filteredOperatorList[indexPath.row].operatorName ?? "")
                    
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

extension AllCallingCardVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        self.filteredOperatorList = searchText.isEmpty ? operatorList : operatorList.filter { ($0.operatorName)?.lowercased().contains((searchText).lowercased()) == true  }
        
        if self.filteredOperatorList .count > 0 {
            emptyMsg.isHidden = true
            emptyMsg.text = ""
        }else {
            emptyMsg.isHidden = false
            emptyMsg.text = "Record not found!"
            
        }
        
        //return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        operatorCollection.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        // Hide the cancel button
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
}
