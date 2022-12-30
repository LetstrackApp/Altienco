//
//  FailedGatwayVC.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

protocol GoToRootDelegate{
    func CloseToRoot(dismiss: Bool)
}

import UIKit



class FailedGatwayVC: UIViewController {
    
    typealias alertCompletionBlock = ((Int, String) -> Void)?
    private var block : alertCompletionBlock?

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

//    var delegate: GoToRootDelegate? = nil
    @IBOutlet weak var failedImageView: UIImageView!
    
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            
            self.viewContainer.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var walletBalance: UILabel!
    @IBOutlet weak var reEnter: UIButton!{
        didSet{
                self.reEnter.setupNextButton(title: "TRY AGAIN")
        }
    }
    @IBOutlet weak var homeButton: UIButton!{
        didSet{
                self.homeButton.layer.cornerRadius = self.homeButton.layer.frame.size.height/2
                self.homeButton.layer.borderColor = appColor.purpleColor.cgColor
                self.homeButton.layer.borderWidth = 1.0
                self.homeButton.clipsToBounds=true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.failedImageView.rotate(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.failedImageView.stopRotating()
        }
        // Do any additional setup after loading the view.
    }
    
    static func initialization() -> FailedGatwayVC{
        let alertController = FailedGatwayVC(nibName: xibName.failedGatwayVC, bundle: nil)
        return alertController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
    }
    
    func setupValue(){
        
        if let currencySymbol = UserDefaults.getUserData?.currencySymbol, let walletAmount = UserDefaults.getUserData?.walletAmount{
            self.walletBalance.text = "\(currencySymbol)" + "\(walletAmount)"
        }
    }
    
    @IBAction func backVew(_ sender: Any) {
        hide { _ in
            
        }
    }
    
    @IBAction func close(_ sender: Any) {
        hide { _ in
            self.block??(0,"Home")
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
            
            
            self.bottomConstraint.constant = -getBottomConstant()
            self.view.backgroundColor = UIColor.clear

            DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
                self?.bottomConstraint?.constant = 0
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
            self?.bottomConstraint?.constant = -(self?.getBottomConstant() ?? 0)
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
