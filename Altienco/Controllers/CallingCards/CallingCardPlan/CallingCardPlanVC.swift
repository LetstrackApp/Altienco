//
//  CallingCardPlanVC.swift
//  Altienco
//
//  Created by Deepak on 06/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import StripeCore

class CallingCardPlanVC: UIViewController {
    
    var OperatorID = 0
    var OperatorName = ""
    var OperatorPlanID = 0
    var SelectedIndex = -1
    var viewModel : OPeratorPlansViewModel?
    var allOperator : [OPeratorPlansResponseObj] = []
    var imageUrl = ""
    
    @IBOutlet weak var noDataLabelText: UILabel!
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
            self.nextButton.setupNextButton(title: "GENERATE")
        }
    }
    @IBOutlet weak var walletBalance: UILabel!{
        didSet{
            walletBalance.font = UIFont.SF_Bold(30.0)
            walletBalance.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var ChangeOperator: UIButton!{
        didSet{
            self.ChangeOperator.layer.cornerRadius = self.ChangeOperator.layer.frame.height/2
            self.ChangeOperator.layer.borderColor = appColor.purpleColor.cgColor
            self.ChangeOperator.layer.borderWidth = 1.0
            self.ChangeOperator.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var planContainer: UIView! {
        didSet {
            planContainer.layer.cornerRadius = 10
            planContainer.layer.borderWidth = 1
            planContainer.layer.borderColor = UIColor.init(0xececec).cgColor
        }
    }
    
    @IBOutlet weak var imageContainer: UIView!{
        didSet {
            imageContainer.layer.cornerRadius = 8
            imageContainer.layer.borderWidth = 1
            imageContainer.layer.borderColor = UIColor.init(0xececec).cgColor
        }
    }
    
    
    @IBOutlet weak var headerViewContainer: UIView!{
        didSet{
            self.headerViewContainer.layer.cornerRadius = 5.0
            self.headerViewContainer.backgroundColor = appColor.lightGrayBack
            self.headerViewContainer.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.setupNextButton(title: lngConst.add_Balance,space: 1.6)
            self.addButton.setTitle(lngConst.add_Balance, for: .normal)

        }
    }
    
    @IBOutlet weak var operatorLogo: UIImageView!
    @IBOutlet weak var operatorPlansCollection: UICollectionView! {
        didSet {
            operatorPlansCollection.delegate = self
            operatorPlansCollection.dataSource = self
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.layer.cornerRadius = 10
            viewContainer.addShadow()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OPeratorPlansViewModel()
        self.operatorPlansCollection.register(UINib(nibName: "CollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.initiateModel()
        onLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    
    
    func onLanguageChange(){
        
        self.generateCollingCard.changeColorAndFont(mainString: lngConst.generatecCllingCard.capitalized,
                                                    stringToColor: lngConst.callingCard.capitalized,
                                                    color: UIColor.init(0xb24a96),
                                                    font: UIFont.SF_Medium(18))
        
        self.selectDenomination.changeColorAndFont(mainString: lngConst.pleaseSelectDenomination.capitalized,
                                                   stringToColor: lngConst.denomination.capitalized,
                                                   color: .black,
                                                   font: UIFont.SF_Regular(16))
        
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
        self.setupLeftnavigation()
        self.setUpCenterViewNvigation()
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
        if self.imageUrl != ""{
            self.operatorLogo.sd_setImage(with: URL(string: self.imageUrl), placeholderImage: UIImage(named: "ic_operatorThumbnail"))
        }
        else{
            self.operatorLogo.image = UIImage(named: "ic_operatorThumbnail")
        }
        
    }
    
    
    @IBAction func showWallet(_ sender: Any)
    {
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func changeOperator(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initiateModel() {
        viewModel?.getOperatorPlans(OperatorID: self.OperatorID, transactionTypeId: TransactionTypeId.CallingCard.rawValue, langCode: "en") { (operatorList, status, message) in
            if status == true && message == ""{
            self.allOperator = operatorList ?? []
            DispatchQueue.main.async {
                self.operatorPlansCollection.reloadData()
            }}
            else{
                self.showAlert(withTitle: "", message: message)
            }
            self.allOperator.count > 0 ? (self.noDataLabelText.isHidden = true) : (self.noDataLabelText.isHidden = false)
        }
        
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func generateVoucher(_ sender: Any) {
        
        
        
        if SelectedIndex != -1{
            guard let selectedAmount = self.allOperator[self.SelectedIndex].denominationValue else {return}
            guard let walletBal = UserDefaults.getUserData?.walletAmount else {return}
            if selectedAmount > Int(walletBal){
                let alertController = UIAlertController(title: "Insufficent Balance", message: "Please add wallet balance", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "ADD", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let viewController: WalletPaymentVC = WalletPaymentVC()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
        
        guard let selectedAmount = self.allOperator[self.SelectedIndex].denominationValue else {return}
        guard let walletBal = UserDefaults.getUserData?.walletAmount else {return}
        if selectedAmount > Int(walletBal){
            let alertController = UIAlertController(title: "Insufficent Balance", message: "Please add wallet balance", preferredStyle: .alert)
                // Create the actions
            let okAction = UIAlertAction(title: "ADD", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                let viewController: WalletPaymentVC = WalletPaymentVC()
                self.navigationController?.pushViewController(viewController, animated: true)
                }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            if self.SelectedIndex < (self.allOperator.count ?? 0) && self.SelectedIndex != -1{
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
        } else{
            self.showAlert(withTitle: "", message: "Please select denomination!")
        }
    }
    
    func successVoucher(mPin: String, denominationValue : String, walletBalance: Double, msgToShare: String, voucherID: Int){
        let viewController: SuccessCallinCardVC = SuccessCallinCardVC()
        viewController.denominationValue = denominationValue
        viewController.mPin = mPin
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func callSuccessPopup(operatorTitle: String, denomination: Int, currency: String, operatorID: Int, planName: String){
        
        let reviewPopupModel = ReviewPopupModel.init(mobileNumber: nil,
                                                     operatorID: operatorID,
                                                     denomination: denomination,
                                                     operatorTitle: operatorTitle,
                                                     planName: planName,
                                                     currency: currency,
                                                     isEdit:false,
                                                     transactionTypeId: TransactionTypeId.CallingCard.rawValue)
        
        ReviewPopupVC.initialization().showAlert(usingModel: reviewPopupModel) { result, status in
            DispatchQueue.main.async {
                if status == true, let val = result{
                    self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
                }
            }
        }
        
//        let viewController: CallingCardReviewVC = CallingCardReviewVC()
//        viewController.delegate = self
//        viewController.denomination = denomination
//        viewController.currency = currency
//        viewController.operatorTitle = operatorTitle
//        viewController.operatorID = operatorID
//        viewController.isEdit = false
//        viewController.planName = planName
//        viewController.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(viewController, animated: true)
    }
    
}

//extension CallingCardPlanVC: BackToUKRechargeDelegate {
//    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?) {
//        if status, let val = result{
//            self.successVoucher(mPin: val.mPIN ?? "", denominationValue: "\(val.dinominationValue ?? 0)", walletBalance: val.walletAmount ?? 0.0, msgToShare: val.msgToShare ?? "", voucherID: val.voucherID ?? 0)
//        }
//        }
//}


extension CallingCardPlanVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allOperator.count ?? 0
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
        if indexPath.row < self.allOperator.count ?? 0{
            DispatchQueue.main.async {
                self.SelectedIndex = indexPath.row
                self.operatorPlansCollection.reloadData()
            }
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
