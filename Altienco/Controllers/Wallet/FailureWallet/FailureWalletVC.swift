//
//  FailureWalletVC.swift
//  Altienco
//
//  Created by Ashish on 25/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class FailureWalletVC: UIViewController {

    var denominationPrice = ""
    var walletAmount = ""
    @IBOutlet weak var failedImageView: UIImageView!
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
    
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var reEnter: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.reEnter.setupNextButton(title: "RE-ENTER PIN")
            }
        }
    }
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.failedImageView.rotate(duration: 0.5)
        self.view.bounds.origin.y = -self.view.bounds.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
        self.setupAlphaVC()
    }
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }

    @IBAction func backVew(_ sender: Any) {
        self.dismissAlphaView()
    }
}



extension UIViewController{
    func setupAlphaVC(){
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.bounds.origin.y = 0
        })
    }
    
    func dismissAlphaView(){
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.bounds.origin.y = -self.view.bounds.height
        }, completion: {_ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
