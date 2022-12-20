//
//  IntrSuccessVC.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SVProgressHUD

class IntrSuccessVC: UIViewController {

    var isFromHistory = false
    var processStatusID = 0
    var externalId = ""
    var processStatus : VerifyStatusViewModel?
    var confirmStatus : VerifyStatusResponce?
    
    var countryModel : SearchCountryModel? = nil
    var selectedOperator : OperatorList? = nil
    var planHistoryResponse: [LastRecharge]? = []
    var mobileNumber : String?
    
    var rechargeTimer: Timer?
    var timerCount = 18
    
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
    @IBOutlet weak var howToUseView: UIView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var instructionButton: UIButton!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    
    @IBOutlet weak var showView: UIStackView!
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
    @IBOutlet weak var destinationAmount: UILabel!
    @IBOutlet weak var destinationUnit: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var operatorName: UILabel!
    
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var validity: UILabel!
    @IBOutlet weak var planDesc: UILabel!
    @IBOutlet weak var sourceAmountMsg: UILabel!
    @IBOutlet weak var failureView: UIStackView!
    @IBOutlet weak var failImageView: UIImageView!
    @IBOutlet weak var successView: UIStackView!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var successRechargeText: UILabel!
    @IBOutlet weak var failedRechargeText: UILabel!
    
    @IBOutlet weak var rechargeRepeat: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.rechargeRepeat.setupNextButton(title: "ANOTHER RECHARGE")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        self.showView.isHidden = true
        (isFromHistory == false) ? (self.rechargeRepeat.isHidden = false) : (self.rechargeRepeat.isHidden = true)
        processStatus = VerifyStatusViewModel()
//        self.setupData()
        self.successImageView.rotate(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.successImageView.stopRotating()
        }
        DispatchQueue.main.async {
            self.checkStatus()
            self.rechargeTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkStatus), userInfo: nil, repeats: true)
            }
    }
    
    @objc func checkStatus(){
        if timerCount == 0{
            rechargeTimer?.invalidate()
        }
        else{
            self.timerCount = self.timerCount - 1
                self.verifyCardStatus(externalID: self.externalId, processStatusID: self.processStatusID)
        }
        
    }
    
    func verifyCardStatus(externalID: String, processStatusID: Int){
        let dataModel = VerifyStatusRequest.init(externalID: externalID, apiID: "", confirmationExpiryDate: "", processStatusID: processStatusID)
        self.processStatus?.verifyProcessStatus(model: dataModel) { (result, status)  in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if status == true, let data = result{
                    self.confirmStatus = data
                    self.processStatusID = data.processStatusID ?? 0
                    DispatchQueue.main.async {
                        if (self.processStatusID == GiftCardProcessStatus.Cancelled.rawValue) ||  (self.processStatusID == GiftCardProcessStatus.Completed.rawValue){
                            self.rechargeTimer?.invalidate()
                        }
                        self.updateData()
                    }
                    
                }
            }}
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
            self.rechargeRepeat.setupNextButton(title: "GENERATE ANOTHER TOP-UP")
            self.instructionText.text = instruction
        }else{
            self.howToUseView.isHidden = true
            self.rechargeRepeat.setupNextButton(title: "TRY AGAIN")
        }
    }
    
  func updateData(){
      self.finalStatusConatiner.isHidden = true
      self.showView.isHidden = false
      self.failureView.isHidden = true
      self.instructionView.isHidden = true
      self.howToUseView.isHidden = true
      self.successView.isHidden = true
      self.firstStatusView.isHidden = true
      self.secondStatusView.isHidden = true
      self.thirdStatusView.isHidden = true
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
          self.failureView.isHidden = false
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
      if let referenceID = confirmStatus?.referenceID, referenceID != ""{
          self.referenceID.isHidden = false
          self.referenceID.text = "Txn ID: \(referenceID)"
      }
      else{
          self.referenceID.isHidden = true
      }
      self.destinationAmount.text = "\(self.confirmStatus?.destinationAmount ?? 0)"
      self.destinationUnit.text = self.confirmStatus?.destinationUnit
      self.country.text = self.confirmStatus?.countryName
      self.operatorName.text = self.confirmStatus?.operatorName
      self.data.text = self.confirmStatus?.data
      if self.confirmStatus?.validityQuantity == -1{
          self.validity.text = "*Unlimited*"
      }
      else{
          self.validity.text = "\(self.confirmStatus?.validityQuantity ?? 0)" + (self.confirmStatus?.validityUnit ?? "NA")
      }
      self.planDesc.text = self.confirmStatus?.cartItemResponseObjDescription
      self.sourceAmountMsg.text = "You have paid *\(String(format: "%.2f", self.confirmStatus?.retailAmount ?? 0.0)) \(self.confirmStatus?.retailUnit ?? "")* for this recharge"
      self.updateStatusData()
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
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalnace.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    func updateStatusData(){
        if (self.processStatusID == GiftCardProcessStatus.InProgress.rawValue) || (self.processStatusID == GiftCardProcessStatus.NotInitiated.rawValue)
        {
        self.successRechargeText.text = "Recharge for *\(confirmStatus?.rechargedMobileNumber ?? "")* is in process ..."
        }
        else if (self.processStatusID != GiftCardProcessStatus.Cancelled.rawValue)
        {
        self.successRechargeText.text = "Recharge for *\(confirmStatus?.rechargedMobileNumber ?? "")* has been done successfully!"
        }
        else{
            self.failedRechargeText.text = "Recharge for *\(confirmStatus?.rechargedMobileNumber ?? "")* has been done successfully"
        }
        
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func repeatRecharge(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editRecharge(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

}
