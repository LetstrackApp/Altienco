//
//  AddAndShowBalance.swift
//  Altienco
//
//  Created by mac on 17/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AddAndShowBalance: UIControl,ViewLoadable {
    
    internal static var nibName: String = xibName.addAndShowBalance
    
    typealias complitionCloser = (Bool?) -> ()
    private var complition : complitionCloser?
    @IBOutlet weak var addBanlanceView: UIView!
    @IBOutlet weak var viewWithBalance: UIView!

    
    @IBOutlet weak var currentBalanceAmount: UILabel! {
        didSet {
            currentBalanceAmount.font = UIFont.SF_SemiBold(30)
            currentBalanceAmount.textColor = .black
        }
    }
    
    @IBOutlet weak var currentBalanceTitle: UILabel! {
        didSet {
            currentBalanceTitle.textColor = UIColor.init(0x787b80)
            currentBalanceTitle.font = UIFont.SFPro_Light(13)
        }
    }
    
    
    @IBOutlet weak var addAmountButton: UIButton!{
        didSet {
            addAmountButton.addTarget(self, action: #selector(addBalanceAction(_:)), for: .touchUpInside)
            addAmountButton.layer.cornerRadius = 6
            addAmountButton.titleLabel?.setCharacterSpacing(2.1)
            addAmountButton.addTarget(self, action: #selector(addBalanceAction(_:)), for: .touchUpInside)
            addAmountButton.titleLabel?.font = UIFont.SF_Regular(14)
            addAmountButton.setTitleColor(.white, for: .normal)
            addAmountButton.backgroundColor = UIColor.init(0x022a72)
            
            
        }
    }
    
    @IBOutlet weak var welcomeMessage: UILabel!{
        didSet {
            welcomeMessage.font = UIFont.SF_Regular(14)
            welcomeMessage.textColor = UIColor.init(0x787b80)
            welcomeMessage.textAlignment = .center
        }
    }
    
    @IBOutlet weak var addNewBalanceBtn: UIButton!{
        didSet {
            addNewBalanceBtn.layer.cornerRadius = 6
            addNewBalanceBtn.titleLabel?.setCharacterSpacing(2.1)
            addNewBalanceBtn.addTarget(self, action: #selector(addBalanceAction(_:)), for: .touchUpInside)
            addNewBalanceBtn.titleLabel?.font = UIFont.SF_Regular(14)
            addNewBalanceBtn.setTitleColor(.white, for: .normal)
            addNewBalanceBtn.backgroundColor = UIColor.init(0x022a72)
        }
    }
    
    
    @IBAction func addBalanceAction(_ sender : Any){
        complition?(true)
    }
    
    func onLanguageChange() {
        welcomeMessage.text = lngConst.wlecomeAddBalance
        addNewBalanceBtn.setTitle(lngConst.add_newBalance_now, for: .normal)
        addAmountButton.setTitle(lngConst.add, for: .normal)
    }
    
    func configure(with  complition : @escaping complitionCloser) ->Void{
        self.complition = complition
        onLanguageChange()
        if let walletAmount = UserDefaults.getUserData?.walletAmount {
            setUpBalanaceView(walletAmount: walletAmount)
        }
    }
    
    
     func setUpBalanaceView(walletAmount : Double) {
         if let currencySymbol = UserDefaults.getUserData?.currencySymbol {
             currentBalanceAmount.text = "\(currencySymbol)" + "\(walletAmount)"
         }
        if walletAmount > 0 {
            addBanlanceView.isHidden = true
            viewWithBalance.isHidden = false
        }else {
            addBanlanceView.isHidden = false
            viewWithBalance.isHidden = true
       }
        
    }
    
    
    
}
