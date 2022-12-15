//
//  SuccessGatwayVC.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class SuccessGatwayVC: UIViewController {
    var delegate: GoToRootDelegate? = nil
    var denominationPrice = 0.0
    @IBOutlet weak var failedImageView: UIImageView!
    
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
                self.reEnter.setupNextButton(title: "ADD MORE MONEY")
            }
        }
    }
    @IBOutlet weak var homeButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.homeButton.layer.cornerRadius = self.homeButton.layer.frame.size.height/2
                self.homeButton.layer.borderColor = appColor.purpleColor.cgColor
                self.homeButton.layer.borderWidth = 1.0
                self.homeButton.clipsToBounds=true
            }
        }
    }
    
    @IBOutlet weak var descMesg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.failedImageView.rotate(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.failedImageView.stopRotating()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
    }
    
    func setupValue(){
        
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol{
            self.descMesg.text = "Your wallet has been recharged successfully with \(currencySymbol)\(denominationPrice)"
        }
        
    }

    @IBAction func backVew(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
            if let topController = UIApplication.topViewController() {
                topController.dismiss(animated: true, completion: nil)
            }
            else{
                self.dismiss(animated: true)
            }
        })
    }
    
    @IBAction func close(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
                self.delegate?.CloseToRoot(dismiss: true)
            }
            
        }
    }
    
    
}
