//
//  VerifyOtpVC.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import OTPInputView
import OTPFieldView

class VerifyOtpVC: UIViewController, OTPFieldViewDelegate{
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        OTPNumber = otp
     self.callVerifyOTP()
     self.nextButton.isEnabled = true
     self.view.isUserInteractionEnabled = false
     self.nextButton.showLoading()
     self.nextButton.backgroundColor = appColor.buttonBackColor
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }
    
    
   
    var count = 30
    var verifyOTP : VerifyOTP?
    var verifyOTPViewModel : VerifyOTPViewModel?
    var resendOTPViewModel : ResendOTPViewModel?
    var OTPNumber = ""
    @IBOutlet var otpTextFieldView: OTPFieldView!
//    @IBOutlet weak var OTPView: OTPInputView!
    @IBOutlet weak var otpTitle: UILabel!{
        didSet{
            otpTitle.text = lngConst.countrySCTitle
            otpTitle.font = UIFont.SFPro_Light(16.0)
        }
    }
    @IBOutlet weak var otpAlertMSG: UILabel!{
        didSet{
            otpAlertMSG.isUserInteractionEnabled = true
            otpAlertMSG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
            self.otpAlertMSG.textColor = appColor.lightGrayText
            otpAlertMSG.text = lngConst.optAlertMsg + lngConst.resend
            otpAlertMSG.font = UIFont.SF_Regular(14.0)
            let myMutableString = NSMutableAttributedString(string: otpAlertMSG.text ?? "", attributes: [NSAttributedString.Key.font : UIFont.SF_Regular(14.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: appColor.buttonBackColor, range: NSRange(location:21,length: self.otpAlertMSG.text!.count - 21))
            self.otpAlertMSG.attributedText = myMutableString
        }
        
    }
 
    @IBOutlet weak var changeNumber: UIButton!{
        didSet{
            changeNumber.titleLabel?.font = UIFont.SF_Regular(14.0)
            changeNumber.setTitleColor(appColor.lightGrayText, for: .normal)
        }
    }
    @IBOutlet weak var nextButton: LoadingButton!{
        didSet{
            
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 6
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 15.0
                self.viewContainer.clipsToBounds=true
            }
        }
    }
    
    
    typealias alertCompletionBlock = ((UserModel?) -> Void)?
    
    private var block : alertCompletionBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyOTPViewModel = VerifyOTPViewModel()
        resendOTPViewModel = ResendOTPViewModel()
    }
    
   
//    func didFinishedEnterOTP(otpNumber: String) {
//           OTPNumber = otpNumber
//        self.callVerifyOTP()
//        self.nextButton.isEnabled = true
//        self.view.isUserInteractionEnabled = false
//        self.nextButton.showLoading()
//        self.nextButton.backgroundColor = appColor.buttonBackColor
//       }
    
    func setupOtpView(){
            self.otpTextFieldView.fieldsCount = 5
            self.otpTextFieldView.fieldBorderWidth = 2
            self.otpTextFieldView.defaultBorderColor = UIColor.black
            self.otpTextFieldView.filledBorderColor = UIColor.black
            self.otpTextFieldView.cursorColor = UIColor.black
        self.otpTextFieldView.displayType = .square
            self.otpTextFieldView.fieldSize = 40
            self.otpTextFieldView.separatorSpace = 8
            self.otpTextFieldView.shouldAllowIntermediateEditing = true
            self.otpTextFieldView.delegate = self
            self.otpTextFieldView.initializeUI()
        }
    static func initialization() -> VerifyOtpVC{
        let alertController = VerifyOtpVC(nibName: "VerifyOtpVC", bundle: nil)
        return alertController
    }
    
    private func show(){
        DispatchQueue.main.async {
        if  let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            topViewController.addChild(self)
            topViewController.view.addSubview(self.view)
//            self.OTPView.delegateOTP = self
            DispatchQueue.main.async {
                self.setupOtpView()
                self.nextButton.setupNextButton(title: lngConst.proceed)
                self.nextButton.isEnabled = false
                self.nextButton.backgroundColor = appColor.lightGrayBack
            }
            
            self.viewWillAppear(true)
            self.didMove(toParent: topViewController)
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.alpha = 0.0
            self.view.frame = topViewController.view.bounds
            self.viewContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                self.view.alpha = 1.0
                self.viewContainer.alpha = 1.0
                self.viewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
            }, completion: nil)
        }
        }
    }
           
@objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = otpAlertMSG.attributedText?.string else {
            return
        }

        if let range = text.range(of: NSLocalizedString(lngConst.resend, comment: lngConst.resend)),
            recognizer.didTapAttributedTextInLabel(label: otpAlertMSG, inRange: NSRange(range, in: text)) {
            self.startOtpTimer()
        }
    }

    /// Hide Alert Controller
    @objc private func hide(){
        self.view.endEditing(true)
        self.viewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.viewContainer.alpha = 0.0
            self.viewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            
        }) {  (completed) -> Void in
            
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
   
    
//    func otpNotValid() {
//        showPopupAlert(title:"OTP Error", message:"")
//    }
    
    @IBAction func closePopup(_ sender: Any) {
        self.hide()
    }
    
    func callVerifyOTP(){
        if OTPNumber.count == 5{
            verifyUser(Otp: String(describing: OTPNumber))
        }
        else{
            self.showPopupAlert(message: "Oops, Incorrect Passcode. Please try again.")
        }
    }
    
    @IBAction func verifyOTP(_ sender: LoadingButton) {
        if OTPNumber.count == 5{
            self.view.isUserInteractionEnabled = false
            sender.showLoading()
            self.callVerifyOTP()
        }
        
    }
    
    func verifyUser(Otp: String)
    {
        let model = VerifyOTP.init(otp: Otp)
        verifyOTPViewModel?.callData(model: model) { [weak self] (val) in
            self?.view.isUserInteractionEnabled = true
            self?.nextButton.hideLoading()
            if val == true{
                self?.hide()
                self?.block!!(nil)
            }
        }
    }
    
    @IBAction func showPinAction() {
        self.startOtpTimer()
        }
//
    var timer: Timer?
    var totalTime = 30
        
         private func startOtpTimer() {
             self.resendOtp()
                
            }
    
    func resendOtp(){
        let model = ResendOTP.init()
        resendOTPViewModel?.callData(model: model) { [weak self] (status, message) in
            if (status == true || status == false) && message != ""{
            Helper.showToast(message)
                self?.totalTime = 30
                self?.otpAlertMSG.isUserInteractionEnabled = false
                self?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.updateTimer), userInfo: nil, repeats: true)
            }
        }
    }
        
        @objc func updateTimer() {
                print(self.totalTime)
            var lastText = "seconds"
            if self.totalTime <= 1{
                lastText = "second"
            }
            otpAlertMSG.text = lngConst.resendOTP + "in \(self.timeFormatted(self.totalTime)) \(lastText)"
            let myMutableString = NSMutableAttributedString(string: otpAlertMSG.text ?? "", attributes: [NSAttributedString.Key.font : UIFont.SF_Regular(14.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: appColor.highlightTextColor, range: NSRange(location:10,length: self.otpAlertMSG.text!.count - 10))
            self.otpAlertMSG.attributedText = myMutableString
                if totalTime != 0 {
                    totalTime -= 1  // decrease counter timer
                } else {
                    if let timer = self.timer {
                        timer.invalidate()
                        self.otpAlertMSG.isUserInteractionEnabled = true
                        self.otpAlertMSG.textColor = appColor.lightGrayText
                        otpAlertMSG.text = lngConst.optAlertMsg + lngConst.resend
                        let myMutableString = NSMutableAttributedString(string: otpAlertMSG.text ?? "", attributes: [NSAttributedString.Key.font : UIFont.SF_Regular(14.0)!])
                        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: appColor.buttonBackColor, range: NSRange(location:21,length: self.otpAlertMSG.text!.count - 21))
                        self.otpAlertMSG.attributedText = myMutableString
                        self.timer = nil
                    }
                }
            }
        func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            return String(format: "%02d", seconds)
        }

    
    func showPopupAlert(title: String? = "", message: String?, actionTitles:[String?] = ["Okay"], actions:[((UIAlertAction) -> Void)?] = [nil]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func showAlert(usingModel OpenVC : Int,completion : alertCompletionBlock){
        show()
        block = completion
    }
    
    deinit {
        print("deinit");
        timer?.invalidate()
    }
    
}

