//
//  OperatorPlanVC.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import StripeCore
import SkeletonView
class OperatorPlanVC: FloatingPannelHelper {
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var OperatorID = 0
    var OperatorName = ""
    var OperatorPlanID = 0
    var SelectedIndex = -1
    var viewModel : OPeratorPlansViewModel?
    var allOperator : [OPeratorPlansResponseObj] = []
    var imageUrl = ""
    
    @IBOutlet weak var planContainer: UIView! {
        didSet {
            planContainer.layer.cornerRadius = 10
            planContainer.layer.borderWidth = 1
            planContainer.layer.borderColor = UIColor.init(0xececec).cgColor
        }
    }
    @IBOutlet weak var notificationIcon: UIImageView!
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
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            self.nextButton.setupNextButton(title: "GENERATE VOUCHER")
            
        }
    }
    @IBOutlet weak var walletBalance: UILabel!{
        didSet{
            walletBalance.font = UIFont.SF_Bold(30.0)
            walletBalance.textColor = appColor.blackText
        }
    }
    
    @IBOutlet weak var recordNotFound: PaddingLabel! {
        didSet {
            recordNotFound.isHidden = true
            recordNotFound.topInset = 40
            recordNotFound.leftInset = 20
            recordNotFound.rightInset = 20
            recordNotFound.font = UIFont.SF_Regular(16)
            recordNotFound.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var generateCollingCard: UILabel!{
        didSet {
            generateCollingCard.font = UIFont.SFPro_Light(18)
        }
    }
    @IBOutlet weak var selectDenomination: UILabel! {
        didSet {
            selectDenomination.font = UIFont.SF_Regular(14)
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.setTitle(lngConst.add_Balance, for: .normal)

            self.addButton.setupNextButton(title: lngConst.add_Balance,space: 1.6)
        }
    }
    
    @IBOutlet weak var imageContainer: UIView!{
        didSet {
            imageContainer.layer.cornerRadius = 8
            imageContainer.layer.borderWidth = 1
            imageContainer.layer.borderColor = UIColor.init(0xececec).cgColor
        }
    }
    
    @IBOutlet weak var operatorLogo: UIImageView!
    @IBOutlet weak var operatorPlansCollection: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
            self.viewContainer.layer.shadowRadius = 5
            self.viewContainer.layer.shadowOffset = .zero
            self.viewContainer.layer.shadowOpacity = 1
            self.viewContainer.layer.cornerRadius = 8.0
            self.viewContainer.clipsToBounds=true
            self.viewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var planVIew: UIView!
    convenience init(OperatorID : Int,
                     OperatorName: String,
                     imageUrl:String) {
        self.init(nibName: xibName.operatorPlanVC, bundle: nil)
        self.OperatorID = OperatorID
        self.OperatorName = OperatorName
        self.imageUrl = imageUrl
        self.viewModel = OPeratorPlansViewModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.operatorPlansCollection.register(UINib(nibName: "CollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.initiateModel()
        onLanguageChange()
    }
    
    
    func onLanguageChange(){
        
        self.generateCollingCard.changeColorAndFont(mainString: lngConst.generate_voucher.capitalized,
                                                    stringToColor: lngConst.voucher.capitalized,
                                                    color: UIColor.init(0xb24a96),
                                                    font: UIFont.SF_Medium(18))
        
        self.selectDenomination.changeColorAndFont(mainString: lngConst.pleaseSelectDenomination.capitalized,
                                                   stringToColor: lngConst.denomination.capitalized,
                                                   color: .black,
                                                   font: UIFont.SF_Regular(16))
        
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
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName {
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount {
            self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
        if self.imageUrl != ""{
            self.operatorLogo.sd_setImage(with: URL(string: self.imageUrl), placeholderImage: UIImage(named: "ic_operatorLogo"))
        }
        else{
            self.operatorLogo.image = UIImage(named: "ic_operatorLogo")
        }
        
    }
    
    
    
    func initiateModel() {
        
        operatorPlansCollection.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)),
                                                             animation: nil,
                                                             transition: .crossDissolve(0.26))
        viewModel?.getOperatorPlans(OperatorID: self.OperatorID,
                                    transactionTypeId: TransactionTypeId.PhoneRecharge.rawValue,
                                    langCode: "en") { [weak self] (operatorList, status, message) in

            DispatchQueue.main.async {
                self?.operatorPlansCollection.stopSkeletonAnimation()
                self?.operatorPlansCollection.hideSkeleton()
                self?.operatorPlansCollection.reloadData()
                self?.view.layoutIfNeeded()
                if status == true && message == ""{
                    self?.nextButton.isHidden = false
                    self?.planVIew.isHidden = false
                    self?.allOperator = operatorList ?? []
                    self?.recordNotFound.isHidden = true
                    
                    self?.operatorPlansCollection.reloadData()
                    if self?.allOperator.count ?? 0 > 0 {
                        let height = self?.operatorPlansCollection.collectionViewLayout.collectionViewContentSize.height
                        self?.collectionViewHeight.constant = height ?? 0
                    }else {
                        self?.collectionViewHeight.constant = 100
                    }
                    self?.operatorPlansCollection.reloadData()
                    
                    
                }
                else{
                    self?.collectionViewHeight.constant = 100
                    self?.nextButton.isHidden = true
                    self?.planVIew.isHidden = true
                    // self?.showAlert(withTitle: "", message: message)
                    self?.recordNotFound.isHidden = false
                    self?.recordNotFound.text = lngConst.supportMsg
                }
            }
        }
        
    }
    func insuffiCentBlanceAlert(){
        AltienoAlert.initialization().showAlertWithBtn(with: .attension("Please add wallet balance"), title: "Insufficent Balance", cancelBtn: "Cancel", okBtn: "ADD") { index, title in
            DispatchQueue.main.async {
                if index == 0 {
                let viewController: WalletPaymentVC = WalletPaymentVC()
                self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func generateVoucher(_ sender: Any) {
        if SelectedIndex != -1{
            guard let selectedAmount = self.allOperator[self.SelectedIndex].denominationValue else {return}
            guard let walletBal = UserDefaults.getUserData?.walletAmount else {return}
            if selectedAmount > Int(walletBal){
                
                insuffiCentBlanceAlert()
            }
            else{
                if self.SelectedIndex < (self.allOperator.count ) && self.SelectedIndex != -1{
                    DispatchQueue.main.async {
                        let operatorTitle = self.OperatorName
                        let planName = self.allOperator[self.SelectedIndex].planName ?? ""
                        let currency = self.allOperator[self.SelectedIndex].currency ?? ""
                        let denomination = self.allOperator[self.SelectedIndex].denominationValue ?? 0
                        self.callSuccessPopup(operatorTitle: operatorTitle,
                                              denomination: denomination,
                                              currency: currency,
                                              operatorID: self.OperatorID,
                                              planName: planName)
                    }
                }}
        }
        else{
            
            Helper.shared.showAlertView(message: "Please select denomination!")
        }
    }
    
    
    
    
    
}

//extension OperatorPlanVC: BackToUKRechargeDelegate {
//    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
//        if status, let val = result{
//            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
//        }
//    }
//}



extension OperatorPlanVC:SkeletonCollectionViewDataSource,
                         SkeletonCollectionViewDelegate ,
                         UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allOperator.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == self.SelectedIndex{
            cell.viewContainer.backgroundColor = appColor.blackText
            cell.plansValue.textColor = .white
        }
        else{
            cell.viewContainer.backgroundColor = .white
            cell.plansValue.textColor = appColor.blackText
        }
        cell.isHighlighted = true
        if let planVlaue = self.allOperator[indexPath.row].denominationValue, let currency = self.allOperator[indexPath.row].currency{
            cell.plansValue.text = currency + "\(planVlaue)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.allOperator.count {
            self.SelectedIndex = indexPath.row
            self.operatorPlansCollection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  15
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/4, height: collectionViewSize/4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.viewContainer.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.viewContainer.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    
    
}

//MARK: - Routing
extension OperatorPlanVC {
    @IBAction func notification(_ sender: Any) {
        setupAllNoti()
    }
    
//    func successVoucher(mPin: String,
//                        denominationValue : String,
//                        walletBalance: Double,
//                        msgToShare: String,
//                        voucherID: Int,
//                        orderNumber:String?){
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
    
    func callSuccessPopup(operatorTitle: String,
                          denomination: Int,
                          currency: String,
                          operatorID: Int,
                          planName: String)  {
        
        
//        let viewController: ReviewPopupVC = ReviewPopupVC()
//        viewController.delegate = self
        let reviewPopupModel = ReviewPopupModel.init(mobileNumber: nil,
                                          operatorID: operatorID,
                                          denomination: denomination,
                                          operatorTitle: operatorTitle,
                                          planName: planName,
                                          currency: currency,
                                          isEdit:false,
                                                     transactionTypeId: TransactionTypeId.PhoneRecharge.rawValue)
        ReviewPopupVC.initialization().showAlert(usingModel: reviewPopupModel) { result,resultThirdParty, status in
          
            DispatchQueue.main.async {
                if status == true {
                    self.successVoucher(thirdPartyVoucher: resultThirdParty, altinecoVoucher: result)
                }
            }
        }
//        viewController.reviewPopupModel = reviewPopupModel
//        let popup = PopupDialog(viewController: viewController,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .bounceUp,
//                                tapGestureDismissal: false,
//                                panGestureDismissal: false)
        
        // Create first button
        
        // Present dialog
//        present(popup, animated: true, completion: nil)
//        viewController.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(viewController, animated: true)
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showWallet(_ sender: Any)
    {
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func changeOperator(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
