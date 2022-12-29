//
//  SuccessGiftCardVC.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import FlagKit

class SuccessGiftCardVC: FloatingPannelHelper {
    
    var denominationAmount = 0.0
    var countryCode = ""
    var countryName = ""
    var processStatusID = 0
    var GiftCardName = ""
    var externalId = ""
    
    var giftCardTimer: Timer?
    var timerCount = 18
    var isHideVoucherButton = false
    var processStatus : VerifyStatusViewModel?
    var confirmStatus : VerifyStatusResponce?
    
    
    var isFromHistory = false
    var showInstruction = false
    
    var receiptDownload: DownloadRecieptApi?
    var orderNumber: String?
    
    @IBOutlet weak var statusCount: UILabel!
    @IBOutlet weak var firstStatusView: UIStackView!
    @IBOutlet weak var secondStatusView: UIStackView!
    @IBOutlet weak var thirdStatusView: UIStackView!
    @IBOutlet weak var firstStatusDay: UILabel!
    @IBOutlet weak var firstStatusDate: UILabel!
    @IBOutlet weak var firstStatusTime: UILabel!
    @IBOutlet weak var seconfStatusDay: UILabel!
    @IBOutlet weak var thirdStatusDay: UILabel!
    @IBOutlet weak var thirdStatusDate: UILabel!
    @IBOutlet weak var thirdStatusTime: UILabel!
    @IBOutlet weak var referenceID: UILabel!
    
    @IBOutlet weak var secondStatusDate: UILabel!
    @IBOutlet weak var secondStatusTime: UILabel!
    
    @IBOutlet weak var statusContainer: UIView!
    
    @IBOutlet weak var firstStatusIndicator: UIView!{
        didSet{
            firstStatusIndicator.layer.cornerRadius = firstStatusIndicator.layer.frame.size.width/2
            firstStatusIndicator.clipsToBounds = true
        }
    }
    @IBOutlet weak var secondStatusIndicator: UIView!{
        didSet{
            secondStatusIndicator.layer.cornerRadius = secondStatusIndicator.layer.frame.size.width/2
            secondStatusIndicator.clipsToBounds = true
        }
    }
    @IBOutlet weak var thirdStatusIndicator: UIView!{
        didSet{
            thirdStatusIndicator.layer.cornerRadius = self.thirdStatusIndicator.layer.frame.size.width/2
            thirdStatusIndicator.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var finalStatusConatiner: UIView!
    @IBOutlet weak var finalStatusMessage: UILabel!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 6
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
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
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var denominationText: UILabel!
    @IBOutlet weak var giftCardName: UILabel!
    @IBOutlet weak var giftCardCountry: UILabel!
    @IBOutlet weak var generateButton: UIButton!{
        didSet{
            self.generateButton.setupNextButton(title: "BUY ANOTHER GIFT CARD", space: 1.5)
        }
    }
    @IBOutlet weak var countryLogo: UIImageView!
    
    @IBOutlet weak var falureView: UIStackView!
    @IBOutlet weak var failImageView: UIImageView!
    @IBOutlet weak var successView: UIStackView!
    @IBOutlet weak var copyShareView: UIView!
    @IBOutlet weak var howToUseView: UIView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var instructionButton: UIButton!
    
    @IBOutlet weak var cardDetailView: UIView!{
        didSet{
            cardDetailView.layer.cornerRadius = 6.0
            cardDetailView.layer.borderWidth = 0.5
            cardDetailView.layer.borderColor = appColor.lightGrayBack.cgColor
            cardDetailView.clipsToBounds = true
        }
    }
    @IBOutlet weak var claimCode: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var buyButtonConatiner: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptDownload = DownloadRecieptApi()
        
        processStatus = VerifyStatusViewModel()
        self.checkStatus()
        self.showStatusMsg(processStatusID: self.processStatusID)
        DispatchQueue.main.async {
            self.updateDefaultVal()
            self.giftCardTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkStatus), userInfo: nil, repeats: true)
        }
    }
    
    func setupFlag(countryCode: String){
        let flag = Flag(countryCode: countryCode)
        let originalImage = flag?.originalImage
        countryLogo.image = originalImage
    }
    
    
    func reVerifyCard(){
        guard let currency = UserDefaults.getUserData?.currencySymbol else {return}
        self.denominationText.text = currency +
        String(format: "%.2f", self.denominationAmount)
        self.showStatusMsg(processStatusID: self.processStatusID)
        self.giftCardName.text = GiftCardName
        self.giftCardCountry.text = self.countryName
        //            self.setupFlag(countryCode: self.countryCode)
    }
    
    @objc func checkStatus(){
        if timerCount == 0{
            giftCardTimer?.invalidate()
        }
        else{
            self.timerCount = self.timerCount - 1
            self.verifyCardStatus(externalID: self.externalId, processStatusID: self.processStatusID)
        }
        
    }
    
    func updateLocalData(){
        if let model = self.confirmStatus{
            //            self.countryCode = model.countryName
            self.countryName = model.countryName ?? ""
            self.processStatusID = model.processStatusID ?? 0
            self.GiftCardName = model.operatorName ?? ""
            self.externalId = model.externalID ?? ""
        }
    }
    
    func verifyCardStatus(externalID: String, processStatusID: Int){
        let dataModel = VerifyStatusRequest.init(externalID: externalID, apiID: "", confirmationExpiryDate: "", processStatusID: processStatusID)
        self.processStatus?.verifyProcessStatus(model: dataModel) { (result, status)  in
            DispatchQueue.main.async { [weak self] in
                if status == true, let data = result{
                    if data.processStatusID == GiftCardProcessStatus.Cancelled.rawValue ||  data.processStatusID == GiftCardProcessStatus.Completed.rawValue{
                        self?.giftCardTimer?.invalidate()
                        self?.giftCardTimer = nil
                    }
                    
                    self?.confirmStatus = data
                    self?.orderNumber = data.orderId 
                    self?.updateLocalData()
                    self?.updateFinalView()
                    
                }
            }
        }
    }
    
    func updateFinalView(){
        
        if let claimCode = self.confirmStatus?.claimCode{
            self.claimCode.text = claimCode
        }
        if let expiryDate = self.confirmStatus?.expiryDate{
            self.expiryDate.text = expiryDate.giftCardFormat()
        }
        if let referenceID = confirmStatus?.referenceID, referenceID != ""{
            self.referenceID.isHidden = false
            self.referenceID.text = "Txn ID: \(referenceID)"
        }
        else{
            self.referenceID.isHidden = true
        }
        (self.isFromHistory == true) ?
        (self.buyButtonConatiner.isHidden = true) : (self.buyButtonConatiner.isHidden = false)
        self.showStatusMsg(processStatusID : self.processStatusID)
        self.reVerifyCard()
    }
    
    func setupFirstStatus(){
        //        UIView.animate(withDuration: 0.0) {
        self.firstStatusView.isHidden = false
        //          }
        self.statusCount.text = "1/3"
        self.firstStatusDay.text = confirmStatus?.firstStep_ActivityDate?.dateFormat()
        self.firstStatusDate.text = confirmStatus?.firstStep_ActivityDate?.dayFormat()
        self.firstStatusTime.text = confirmStatus?.firstStep_ActivityDate?.timeFormat()
    }
    func setupSecondStatus(){
        //        UIView.animate(withDuration: 0.0) {
        self.secondStatusView.isHidden = false
        //          }
        self.statusCount.text = "2/3"
        self.seconfStatusDay.text = confirmStatus?.firstStep_ActivityDate?.dateFormat()
        self.secondStatusDate.text = confirmStatus?.firstStep_ActivityDate?.dayFormat()
        self.secondStatusTime.text = confirmStatus?.firstStep_ActivityDate?.timeFormat()
    }
    func setupFinalStatus(){
        UIView.animate(withDuration: 0.0) {
            self.thirdStatusView.isHidden = false
        }
        self.statusCount.text = "3/3"
        self.thirdStatusDay.text = confirmStatus?.firstStep_ActivityDate?.dateFormat()
        self.thirdStatusDate.text = confirmStatus?.firstStep_ActivityDate?.dayFormat()
        self.thirdStatusTime.text = confirmStatus?.firstStep_ActivityDate?.timeFormat()
        if let instruction = confirmStatus?.usageInfo, confirmStatus?.processStatusID == GiftCardProcessStatus.Completed.rawValue{
            self.howToUseView.isHidden = false
            self.generateButton.setupNextButton(title: "BUY ANOTHER GIFT CARD")
            self.instructionText.text = instruction
        }else{
            self.howToUseView.isHidden = true
            self.generateButton.setupNextButton(title: "TRY AGAIN")
        }
    }
    
    
    func showStatusMsg(processStatusID : Int){
        self.falureView.isHidden = true
        self.instructionView.isHidden = true
        self.howToUseView.isHidden = true
        self.successView.isHidden = true
        self.cardDetailView.isHidden = true
        self.firstStatusView.isHidden = true
        self.secondStatusView.isHidden = true
        self.thirdStatusView.isHidden = true
        self.copyShareView.isHidden = true
        self.statusContainer.isHidden = false
        if processStatusID == GiftCardProcessStatus.NotInitiated.rawValue{
            self.setupFirstStatus()
        }
        else if processStatusID == GiftCardProcessStatus.InProgress.rawValue{
            self.setupFirstStatus()
            self.setupSecondStatus()
        }
        else if processStatusID == GiftCardProcessStatus.Completed.rawValue{
            self.successView.isHidden = false
            self.cardDetailView.isHidden = false
            self.copyShareView.isHidden = false
            self.successImageView.rotate(duration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.successImageView.stopRotating()
            }
            self.finalStatusMessage.text = "Transaction Successful"
            self.thirdStatusIndicator.backgroundColor = appColor.buttonGreenColor
            self.finalStatusConatiner.isHidden = false
            self.setupFirstStatus()
            self.setupSecondStatus()
            self.setupFinalStatus()
        }
        else if processStatusID == GiftCardProcessStatus.Cancelled.rawValue{
            self.successView.isHidden = true
            self.falureView.isHidden = false
            self.failImageView.rotate(duration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.failImageView.stopRotating()
            }
            self.finalStatusMessage.text = "Transaction Failed"
            self.thirdStatusIndicator.backgroundColor = appColor.lightGrayBack
            self.finalStatusConatiner.isHidden = false
            self.setupFirstStatus()
            self.setupSecondStatus()
            self.setupFinalStatus()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        giftCardTimer?.invalidate()
        giftCardTimer = nil
    }
    
    
    @IBAction func copyTextButton(_ sender: Any) {
        if !(claimCode.text?.isEmpty ?? true){
            UIPasteboard.general.string = claimCode!.text
            
            AltienoAlert.initialization().showAlert(with: .profile(lngConst.claim_Code_Copied)) { index, _ in

            }
        }
    }
    
    @IBAction func clickInstruction(_ sender: Any) {
        if self.showInstruction == false {
            self.showInstruction = true
            UIView.animate(withDuration: 0.6,
                           animations: { [weak self] in
                self?.instructionView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.6,
                           animations: { [weak self] in
                self?.instructionView.isHidden = true
            }) { [weak self] _ in
                self?.showInstruction = false
            }
        }
    }
    
    @IBAction func notification(_ sender: Any) {
        setupAllNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateDefaultVal()
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
    func updateDefaultVal(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
            self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func downloadReceiptAction(_ sender: Any) {
        receiptDownload?.receiptDownload(userId: UserDefaults.getUserID,
                                         orderId: orderNumber,
                                         voicherId: 0,
                                         serviceTypeId:  TransactionTypeId.Giftcard.rawValue) { result in
            // to do
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        // text to share
        if let currency = UserDefaults.getUserData?.currencySymbol{
            self.denominationText.text = currency + String(format: "%.2f", self.denominationAmount)
            let text = self.confirmStatus?.msgToShare
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func generateOther(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func dashboard(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
