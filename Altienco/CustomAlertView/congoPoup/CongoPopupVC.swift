//
//  CongoPopupVC.swift
//  Altienco
//
//  Created by Ashish on 27/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import OTPInputView


class CongoPopupVC: UIViewController{
    var delegate: GoToRootDelegate? = nil
    var walletBalance = 0.0
    var cardValue = 0
    var Message = ""
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
    
    
    @IBOutlet weak var msgDesc: UILabel!
    @IBOutlet weak var addAnother: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.addAnother.setupNextButton(title: "ADD ANOTHER CARD")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.show()
        self.view.bounds.origin.y = -self.view.bounds.height
//        verifyOTPViewModel = VerifyOTPViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupDefaultValue()
        //self.setupAlphaVC()
    }
    
    private func show(){
            self.msgDesc.text = "You have added £\(self.cardValue) successfully in your altienco wallet"
        
    }
    func setupDefaultValue(){
        var model = UserDefaults.getUserData
        model?.walletAmount = walletBalance
        if model != nil{
            UserDefaults.setUserData(data: model!)
        }
    }
    @IBAction func backVew(_ sender: Any) {
        
    }
    
    @IBAction func close(_ sender: Any) {
        
    }
    
    @IBAction func addWallet(_ sender: Any) {
//        DispatchQueue.main.async {
//            if let topController = UIApplication.topViewController() {
//                topController.dismissAlphaView()
//            }
//            else{
//                self.dismissAlphaView()
//            }
//        }
    }
    
    @IBAction func homeBuuton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.view.bounds.origin.y = -self.view.bounds.height
                self.delegate?.CloseToRoot(dismiss: true)
            }
            
        }
    }
    
    
}

