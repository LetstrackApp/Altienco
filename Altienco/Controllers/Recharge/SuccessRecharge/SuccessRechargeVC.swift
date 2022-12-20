//
//  SuccessRechargeVC.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//
import Foundation
import UIKit

class SuccessRechargeVC: UIViewController, UITextFieldDelegate {

    var denominationValue = ""
    var mPin = ""
    var isHideVoucherButton = false
    var isUsed = false
    var msgToShare = ""
    var walletBal = 0.0
    var voucherID = 0
    var markUsed : UsedMarkViewModel?
    
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
    @IBOutlet weak var statusMark: UIButton!
    @IBOutlet weak var mPinText: UILabel!
    
    @IBOutlet weak var otherVoucherView: UIView!
    @IBOutlet weak var notifiationIcon: UIImageView!
    @IBOutlet weak var generateButton: UIButton!{
        didSet{
            self.generateButton.setupNextButton(title: "GENERATE ANOTHER VOUCHER", space: 1.5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markUsed = UsedMarkViewModel()
        if self.walletBal != 0.0{
        DispatchQueue.main.async {
            self.setupDefaultValue()
        }}
        self.initiateView()
    }
    func setupDefaultValue(){
        var model = UserDefaults.getUserData
        model?.walletAmount = walletBal
        if model != nil{
            UserDefaults.setUserData(data: model!)
            if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = model?.walletAmount{
                self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
            }
        }
        
    }
    
    func initiateView(){
        if let currency = UserDefaults.getUserData?.currencySymbol{
        self.denominationText.text = currency + denominationValue
            var str4 = mPin
            str4.insert(separator: " ", every: 4)
            print(str4)   // "1123:1245:1\n"
            self.mPinText.text = str4
            self.successImageView.rotate(duration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successImageView.stopRotating()
            }
            self.setStatusMark()
            self.isHideVoucherButton == true ? (self.otherVoucherView.isHidden = true) : (self.otherVoucherView.isHidden = false)
        }
    }
    
    func setStatusMark(){
        (self.isUsed == true) ?
        self.statusMark.setImage(UIImage(named: "CheckSquare"), for: .normal) : self.statusMark.setImage(UIImage(named: "UncheckSquare"), for: .normal)
    }
    
    func markToUsed(){
        if let customerID = UserDefaults.getUserData?.customerID{
            let model = UsedMarkModel.init(customerID: "\(customerID)", voucherID: "\(self.voucherID)", isUsed: !self.isUsed, langCode: "en")
            markUsed?.setMarkAsUsed(model: model) { (status) in
                if status == true{
                    (self.isUsed == true) ? (self.isUsed = false) : (self.isUsed = true)
                    self.setStatusMark()
                }
            }
        }
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func setStatus(_ sender: Any) {
            self.markToUsed()
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
            self.notifiationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notifiationIcon.image = UIImage(named: "ic_notification")
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
    
    @IBAction func copyTextButton(_ sender: Any) {
        UIPasteboard.general.string = mPinText!.text 
        Helper.showToast("Voucher Code Copied Successfully")

    }
    
    @IBAction func rechargeButton(_ sender: Any) {
        self.mPin != "" ?
            self.present(alertEmailAddEditView, animated: true, completion: nil) : Helper.showToast("Please try after Sometime!")
        }
    //Create Alert Controller Dial Object here
    lazy var alertEmailAddEditView:UIAlertController = {

        let alert = UIAlertController(title:"Recharge Voucher", message: "Customize Voucher Code Before Dial", preferredStyle:UIAlertController.Style.alert)

        //ADD TEXT FIELD (YOU CAN ADD MULTIPLE TEXTFILED AS WELL)
        alert.addTextField { (textField : UITextField!) in
            textField.text = self.mPin
            textField.keyboardType = .phonePad
            textField.delegate = self
        }

        //SAVE BUTTON
        let save = UIAlertAction(title: "Dial", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            let textField = alert.textFields![0] as UITextField
            if let url = URL(string: "telprompt://\(textField.text!)"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        //CANCEL BUTTON
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })


        alert.addAction(save)
        alert.addAction(cancel)

        return alert
    }()

    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func shareButton(_ sender: Any) {
        // text to share
        if let currency = UserDefaults.getUserData?.currencySymbol{
        self.denominationText.text = currency + denominationValue
            var str4 = mPin
            str4.insert(separator: " ", every: 4)
            print(str4)   // "1123:1245:1\n"
            
            let text = msgToShare
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
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
    
    @IBAction func generateOther(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
