//
//  ReferAppVC.swift
//  Altienco
//
//  Created by Deepak on 06/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class ReferAppVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var descLabel: UILabel!{
        didSet{
            
        }
    }
    @IBOutlet weak var firstTextField: BackTextField!{
        didSet{
            self.firstTextField.layer.cornerRadius = 6.0
            self.firstTextField.layer.borderWidth = 1
            self.firstTextField.layer.borderColor = appColor.otpBorderColor.cgColor
            self.firstTextField.clipsToBounds=true
        }
    }
    @IBOutlet weak var footerBanner: UIImageView!
    @IBOutlet weak var inviteBanner: UIImageView!
    @IBOutlet weak var secondTextField: BackTextField!{
        didSet{
            self.secondTextField.layer.cornerRadius = 6.0
            self.secondTextField.layer.borderWidth = 1
            self.secondTextField.layer.borderColor = appColor.otpBorderColor.cgColor
            self.secondTextField.clipsToBounds=true
        }
    }
    
    @IBOutlet weak var thirdTextfield: BackTextField!{
        didSet{
            self.thirdTextfield.layer.cornerRadius = 6.0
            self.thirdTextfield.layer.borderWidth = 1
            self.thirdTextfield.layer.borderColor = appColor.otpBorderColor.cgColor
            self.thirdTextfield.clipsToBounds=true
        }
    }
    @IBOutlet weak var forthTextfield: BackTextField!{
        didSet{
            self.forthTextfield.layer.cornerRadius = 6.0
            self.forthTextfield.layer.borderWidth = 1
            self.forthTextfield.layer.borderColor = appColor.otpBorderColor.cgColor
            self.forthTextfield.clipsToBounds=true
        }
    }
    @IBOutlet weak var fifthTextfield: BackTextField!{
        didSet{
            self.fifthTextfield.layer.cornerRadius = 6.0
            self.fifthTextfield.layer.borderWidth = 1
            self.fifthTextfield.layer.borderColor = appColor.otpBorderColor.cgColor
            self.fifthTextfield.clipsToBounds=true
        }
    }
    
    @IBOutlet var textfields : [BackTextField]!
    var isFromHome = false
    
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupTextfields()
    }
    
    func setupView(){
        guard let model = UserDefaults.getUserData else {return}
            UserDefaults.setUserData(data: model)
            if let inviteBanner = UserDefaults.getUserData?.inviteBanner{
                self.inviteBanner.contentMode = .scaleToFill
                self.inviteBanner.sd_setImage(with: URL(string: inviteBanner), placeholderImage: UIImage(named: "defaultUser"))
        }
        if let inviteFooter = UserDefaults.getUserData?.inviteFooterBanner{
            self.footerBanner.contentMode = .scaleToFill
            self.footerBanner.sd_setImage(with: URL(string: inviteFooter), placeholderImage: UIImage(named: "defaultUser"))
    }
    }
    func setupTextfields() {
        for textfield in textfields {
          
            textfield.textAlignment = .center
            textfield.textColor = appColor.blackText
            textfield.isUserInteractionEnabled = false
        }
        guard let whideCode = UserDefaults.getUserData?.customerCode else {return}
        let arr = Array(whideCode)
        for i in 1...5 {
            if let theTextField = self.view.viewWithTag(i) as? UITextField {
                theTextField.text = "\(arr[i-1])"
            }
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
            
        guard let text = UserDefaults.getUserData?.msgToShare else {return}
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)    }
    

    
}
