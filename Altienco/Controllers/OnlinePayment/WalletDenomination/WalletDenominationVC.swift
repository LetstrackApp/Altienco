//
//  WalletDenominationVC.swift
//  Altienco
//
//  Created by Deepak on 22/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import StripePaymentSheet

class WalletDenominationVC: UIViewController {
    
    
    var OperatorID = 0
    var OperatorName = ""
    var OperatorPlanID = 0
    var SelectedIndex = -1
    var onlinePaymentIntent : OnlinePaymentIntent?
    var paymentIntentRes = [PaymentIntentResponse]()
    var viewModel : WalletDenomination?
    var resposeData = [WalletDenominationResponse]()
    var verifyPayment : VerifyPaymentViewModel?
    var imageUrl = ""
    var paymentSheet: PaymentSheet?
    
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
    @IBOutlet weak var nextButton: LoadingButton!{
        didSet{
            self.nextButton.setupNextButton(title: "GENERATE VOUCHER")
            self.nextButton.addTarget(self, action: #selector(self.didTapCheckoutButton),
                                      for: .touchUpInside)
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.init(0xf2f2f2)
        }
    }
    @IBOutlet weak var walletBalance: UILabel!{
        didSet{
            walletBalance.font = UIFont.SF_Bold(30.0)
            walletBalance.textColor = appColor.blackText
        }
    }
    
    @IBOutlet weak var planContainer: UIView! {
        didSet {
            planContainer.layer.cornerRadius = 10
        }
    }

    
    @IBOutlet weak var userName: UILabel!
    
    //    @IBOutlet weak var operatorLogo: UIImageView!
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
    
    
    @IBOutlet weak var rechargeWalletTitle: PaddingLabel!{
        didSet {
            rechargeWalletTitle.topInset = 10
            rechargeWalletTitle.leftInset = 15
            rechargeWalletTitle.rightInset = 15
            rechargeWalletTitle.font = UIFont.SFPro_Light(18)
        }
    }
    
    @IBOutlet weak var selectDemimation: UILabel!{
        didSet {
            selectDemimation.font = UIFont.SF_Regular(14)
        }
    }
    
    convenience init() {
        self.init(nibName: xibName.walletDenominationVC, bundle: .altiencoBundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyPayment = VerifyPaymentViewModel()
        onlinePaymentIntent = OnlinePaymentIntent()
        viewModel = WalletDenomination()
        self.operatorPlansCollection.register(UINib(nibName: "CollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        self.initiateModel()
        onLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    func onLanguageChange(){
        
        
        rechargeWalletTitle.changeColorAndFont(mainString: lngConst.rechargeWallet,
                                                    stringToColor: lngConst.wallet,
                                                    color: UIColor.init(0xb24a96),
                                                    font: UIFont.SF_Medium(18))
        
        selectDemimation.changeColorAndFont(mainString: lngConst.pleaseSelectDenomination,
                                                   stringToColor: lngConst.denomination,
                                                   color: .black,
                                                   font: UIFont.SF_Regular(16))
        
    }
    
    func InitializeStripe(){
        STPAPIClient.shared.publishableKey = self.paymentIntentRes.first?.publishableKey
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Altienco"
        configuration.allowsDelayedPaymentMethods = true
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.paymentIntentRes.first?.paymentIntent ?? "", configuration: configuration)
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor.init(0x022a72)
    }
    
    
    func showButtonloading(){
        self.view.isUserInteractionEnabled = false
        self.nextButton.showLoading()
    }
    
    func hideButtonLoading(){
        self.view.isUserInteractionEnabled = true
        self.nextButton.hideLoading()
    }
    
    
    @objc func didTapCheckoutButton() {
        showButtonloading()
        // MARK: Start the checkout process
        paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                self.verifyPaymentCode(clientSKey: self.paymentIntentRes.first?.publishableKey ?? "")
                print("Your order is confirmed")
            case .canceled:
                print("Canceled!")
                self.callFailureScreen()
                self.hideButtonLoading()
                //            self.verifyPaymentCode(clientSKey: self.paymentIntentRes.first?.publishableKey ?? "")
            case .failed(let error):
                self.hideButtonLoading()
                self.alert(message: error.localizedDescription, title: "Alert")
            }
        }
    }
    
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupValue()
        self.updateProfilePic()
        self.showNotify()
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
    
    func verifyPaymentCode(clientSKey: String) {
        let dataModel = VerifyPaymentRequest.init(customerId: UserDefaults.getUserData?.customerID ?? 0,
                                                  clientSKey: clientSKey)
        verifyPayment?.verifyPayment(model: dataModel) { (result, status)  in
            DispatchQueue.main.async { [weak self] in
                if status == true,
                   let responce = result {
                    self?.setupWalletBal(walletBal: responce.first?.WalletAmount ?? 0.0)
                    
                    if let amount = self?.resposeData[self?.SelectedIndex ?? 0].denominationValue {
                        let obj = AlertViewVC.init(type: .transactionSucessfull(amount: amount))
                        obj.modalPresentationStyle = .overFullScreen
                        self?.present(obj, animated: false, completion: nil)
                        obj.onCompletion = {
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self?.hideButtonLoading()
                    }
                    
                    //                    let viewController: SuccessGatwayVC = SuccessGatwayVC()
                    //                    viewController.denominationPrice = Double(self?.resposeData[self?.SelectedIndex ?? 0].denominationValue ?? 0)
                    //                    viewController.delegate = self
                    //                    viewController.modalPresentationStyle = .overFullScreen
                    //                    self?.navigationController?.present(viewController, animated: true)
                }
                else {
                    self?.hideButtonLoading()
                    self?.callFailureScreen()
                }
            }}
    }
    
   
    
    func setupWalletBal(walletBal: Double){
        var model = UserDefaults.getUserData
        model?.walletAmount = walletBal
        if model != nil{
            UserDefaults.setUserData(data: model!)
            if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = model?.walletAmount{
                self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
            }
        }
        
    }
    
    func initiateModel() {
        let dataModel = WalletDenominationRequest.init(currencyCodes: "gbp")
        viewModel?.getDenomination(model: dataModel) { (result, status)  in
            DispatchQueue.main.async { [weak self] in
                if status == true, let data = result {
                    self?.resposeData = data
                    self?.operatorPlansCollection.reloadData()
                }
            }}
    }
  
    
    func getAllKey(){
        if self.SelectedIndex < (self.resposeData.count) && self.SelectedIndex != -1{
            let dataModel = PaymentIntentRequest.init(customerID: UserDefaults.getUserData?.customerID, langCode: "eng", amount: self.resposeData[self.SelectedIndex].denominationValue, currencyCode: "gbp")
            onlinePaymentIntent?.getPaymentIntent(model: dataModel) { (result, status)  in
                DispatchQueue.main.async { [weak self] in
                    if status == true, let data = result {
                        self?.paymentIntentRes = data
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self?.InitializeStripe()
                        })
                        
                    }
                }}
        }
    }
    
    
    
    func successVoucher(mPin: String,
                        denominationValue : String,
                        walletBalance: Double,
                        msgToShare: String,
                        voucherID: Int){
        let viewController: SuccessRechargeVC = SuccessRechargeVC()
        viewController.denominationValue = denominationValue
        viewController.mPin = mPin
        viewController.walletBal = walletBalance
        viewController.voucherID = voucherID
        viewController.msgToShare = msgToShare
        if let topController = UIApplication.topViewController() {
            topController.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}


extension WalletDenominationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resposeData.count
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
        let model = self.resposeData[indexPath.row]
        cell.plansValue.text = (model.currencySymbol ?? "") + "\(model.denominationValue ?? 0)"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.resposeData.count{
            DispatchQueue.main.async {
                self.SelectedIndex = indexPath.row
                self.operatorPlansCollection.reloadData()
                self.getAllKey()
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


extension WalletDenominationVC : GoToRootDelegate {
    func CloseToRoot(dismiss: Bool) {
        if dismiss{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if let topController = UIApplication.topViewController() {
                    topController.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
}

//MARK: - Routing
extension WalletDenominationVC {
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func callFailureScreen(){
        let viewController: FailedGatwayVC = FailedGatwayVC()
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(viewController, animated: true)
    }
}
