//
//  WalletPaymentVC.swift
//  Altienco
//
//  Created by Deepak on 22/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class WalletPaymentVC: UIViewController {
    
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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var walletBalance: UILabel!{
        didSet{
            walletBalance.font = UIFont.SF_Bold(30.0)
            walletBalance.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var confirmCard: UIButton!{
        didSet{
            self.confirmCard.setupNextButton(title: "CONTINUE WITH CARD",
                                             cornerRadius:23)
        }
    }
    
    @IBOutlet weak var whatYouGetDes: UILabel! {
        didSet {
            whatYouGetDes.text = lngConst.whatYouGetDes
            whatYouGetDes.font = UIFont.SFPro_Light(12)
            
        }
    }
    @IBOutlet weak var step2DesLBL: UILabel!{
        didSet {
            step2DesLBL.font = UIFont.SFPro_Light(12)
        }
    }
    @IBOutlet weak var step1DesLBL: UILabel! {
        didSet {
            step1DesLBL.font = UIFont.SFPro_Light(12)
        }
    }
    @IBOutlet weak var whatYouGetLbl: UILabel!{
        didSet {
            whatYouGetLbl.font = UIFont.SF_Regular(12)
        }
    }
    @IBOutlet weak var step2Title: PaddingLabel!{
        didSet {
            step2Title.font = UIFont.SF_Regular(12)
        }
    }
    @IBOutlet weak var step1Title: PaddingLabel!{
        didSet {
            step1Title.font = UIFont.SF_Regular(12)
            step1Title.topInset = 10
        }
    }
    
    @IBOutlet weak var setpView: UIView! {
        didSet {
            setpView.layer.cornerRadius = 10
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var cardImageView: UIImageView! {
        didSet {
            let margin:CGFloat = 10
            self.cardImageView.image = UIImage(named: "ic_altiencoCard")?.withInset(UIEdgeInsets(top: margin, left: 0, bottom: 0, right: 0))
            
        }
    }
    func onLanguageChange() {
        whatYouGetLbl.text = lngConst.what_you_get
        step1DesLBL.text = lngConst.step1Des
        step2DesLBL.text = lngConst.step2Des
        whatYouGetDes.text = lngConst.whatYouGetDes
        
        self.wallietTitle.changeColor(mainString: lngConst.addMoneyToAltiencocard,
                                      stringToColor: lngConst.altiencoCard,
                                      color: UIColor.init(0xb24a96))
        
        step1Title.changefont(mainString: lngConst.step1,
                              fontchangeString: "\u{2022}",
                              font: UIFont.SF_Bold(16))
        
        step2Title.changefont(mainString: lngConst.step2,
                              fontchangeString: "\u{2022}",
                              font: UIFont.SF_Bold(16))
    }
    
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var orLbl: PaddingLabel! {
        didSet {
            orLbl.topInset = 20
            
        }
    }
    
    @IBOutlet weak var wallietTitle: PaddingLabel! {
        didSet {
            wallietTitle.leftInset = 16
            wallietTitle.rightInset = 10
            wallietTitle.font = UIFont.SF_Medium(18)
        }
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
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
    
    @IBAction func scratchCard(_ sender: Any) {
        let viewController: AddCardVC = AddCardVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func onlineRecharge(_ sender: Any) {
        let viewController: WalletDenominationVC = WalletDenominationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}



