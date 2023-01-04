//
//  FailureWalletVC.swift
//  Altienco
//
//  Created by Ashish on 25/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class FailureWalletVC: UIViewController {
    typealias alertCompletionBlock = ((Int, String) -> Void)?
    private var block : alertCompletionBlock?

    @IBOutlet weak var titleLBl: UILabel!
    @IBOutlet weak var bottomConstarint: NSLayoutConstraint!
    var denominationPrice = ""
    var walletAmount = ""
    @IBOutlet weak var failedImageView: UIImageView!

    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            self.viewContainer.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var reEnter: UIButton!{
        didSet{
                self.reEnter.setupNextButton(title: "RE-ENTER PIN")
        }
    }
    
    static func initialization() -> FailureWalletVC{
        let alertController = FailureWalletVC(nibName: xibName.failureWalletVC, bundle: nil)
        return alertController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.failedImageView.rotate(duration: 0.5)
        onLanguageChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
       // self.setupAlphaVC()
    }
    
    func setupValue(){
//        if let firstname = UserDefaults.getUserData?.firstName{
//            self.userName.text = "Hi \(firstname)"
//        }
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
        self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    func onLanguageChange(){
        self.titleLBl.changeColorAndFont(mainString: lngConst.addMoneyToAltiencocard.capitalized,
                                                    stringToColor: lngConst.altiencoCard.capitalized,
                                                    color: UIColor.init(0xb24a96),
                                                    font: UIFont.SF_Medium(18))

    }

    @IBAction func backVew(_ sender: Any) {
       // self.dismissAlphaView()
        hide { _ in
            
        }
    }
    
    func getBottomConstant ()->CGFloat{
        let alertViewHeight = viewContainer.bounds.size.height
        let totalHeight = (alertViewHeight +  (viewContainer.bounds.origin.y))
        let viewHeight = UIScreen.main.bounds.height
        let bottomDistace = (viewHeight - totalHeight) + alertViewHeight
        return bottomDistace
    }
    
    
    /// Show Alert Controller
    private func show(){
        if  let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            topViewController.addChild(self)
            topViewController.view.addSubview(view)
            viewWillAppear(true)
            didMove(toParent: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.frame = UIScreen.main.bounds
            
            
            self.bottomConstarint.constant = -getBottomConstant()
            self.view.backgroundColor = UIColor.clear

            DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
                self?.bottomConstarint?.constant = 0
                UIView.animate(withDuration: 0.6) {
                    self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                }
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
        }
    }
    private func hide(completion:@escaping(Bool)->Void){
        self.view.endEditing(true)
        Helper.shared.isAlertShown = false
        DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
            self?.bottomConstarint?.constant = -(self?.getBottomConstant() ?? 0)
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                self?.viewContainer.alpha = 0.0
                self?.view.alpha = 0
            } completion: { result in
                completion(true)
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            }
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    public func showAlert(completion : alertCompletionBlock) {
        Helper.shared.isAlertShown = true
        show()
        block = completion
    }
}



//extension UIViewController{
//    func setupAlphaVC(){
//        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
//            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//            self.view.bounds.origin.y = 0
//        })
//    }
//
//    func dismissAlphaView(){
//        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
//            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//            self.view.bounds.origin.y = -self.view.bounds.height
//        }, completion: {_ in
//            self.dismiss(animated: false, completion: nil)
//        })
//    }
//
//}
