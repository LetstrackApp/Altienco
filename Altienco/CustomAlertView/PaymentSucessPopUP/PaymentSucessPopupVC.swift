//
//  PaymentSucessPopupVC.swift
//  Altienco
//
//  Created by mac on 22/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Lottie
import UIKit


class PaymentSucessPopupVC: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private var amount: String? = ""

    
    @IBOutlet weak var animatorView: AnimationView!
    
    @IBOutlet weak var titleView: UILabel! {
        didSet {
            titleView.font = UIFont.SF_SemiBold(16)
        }
    }
    @IBOutlet weak var viewAlert: UIView! {
        didSet {
            viewAlert.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var addAnother: UIButton! {
        didSet {
            addAnother.setupNextButton(title: lngConst.proceed)
            addAnother.titleLabel?.font = UIFont.SF_Regular(15)
            addAnother.addTarget(self, action: #selector(addAnotherCardAction(_:)), for: .touchUpInside)
        }
    }
    typealias alertCompletionBlock = ((Int, Bool) -> Void)?
    private var block : alertCompletionBlock?
    
    static func initialization() -> PaymentSucessPopupVC {
        let alertController = PaymentSucessPopupVC(nibName: xibName.paymentSucessPopupVC, bundle: nil)
        return alertController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /// Create and Configure Alert Controller
    private func configure(amount : String?) {
        self.amount = amount
        
    }
    
    /// Show Alert Controller
    private func show() {
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
            view.frame = topViewController.view.bounds
            self.bottomConstraint.constant = -getBottomConstant()
            self.view.backgroundColor = UIColor.clear
            DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
                self?.bottomConstraint?.constant = 0
                UIView.animate(withDuration: 0.6) {
                    self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    self?.animateView()
                }
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
            onLanguageChange(amount: amount)
        }
    }
    
    
    func getBottomConstant ()->CGFloat {
        let alertViewHeight = viewAlert.bounds.size.height
        let totalHeight = (alertViewHeight +  (viewAlert.bounds.origin.y))
        let viewHeight = UIScreen.main.bounds.height
        let bottomDistace = (viewHeight - totalHeight) + alertViewHeight
        return bottomDistace
    }
    /// Hide Alert Controller
    /// Hide Alert Controller
    private func hide(completion:@escaping(Bool)->Void){
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
            self?.bottomConstraint?.constant = -(self?.getBottomConstant() ?? 0)
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                self?.viewAlert.alpha = 0.0
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
    
    
    
    /// Display Alert
    /// - Parameters:
    ///   - model: model to setup View
    ///   - completion: retuen the index or title of the button
    public func showAlert(with amount : String?,
                          completion : alertCompletionBlock){
        configure(amount: amount)
        show()
        block = completion
    }
    
    
    
}

extension PaymentSucessPopupVC {
    
    func onLanguageChange(amount:String?) {
        titleView.text = lngConst.wlecomeAddBalance
        addAnother.setTitle(lngConst.home, for: .normal)
        titleView.changeColor(mainString: lngConst.txnSucessMeg(amount: amount ?? "0"),
                              stringToColor: (amount ?? "0"),
                              color: UIColor.init(0x0f4fca))
        
    }
    
    @IBAction func addAnotherCardAction(_ sender : Any){
        hide {_ in
            self.block??(1,true)
        }
        
    }
    
    func animateView() {
        let animation = Animation.named("txnSuccess")
        animatorView.animation = animation
        animatorView.contentMode = .scaleAspectFit
        animatorView.backgroundBehavior = .pauseAndRestore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            Helper.shared.playSound()
            self?.animatorView.play(fromProgress: 0,
                                    toProgress: 1,
                                    loopMode: LottieLoopMode.playOnce,
                                    completion: { (finished) in
                if finished {
                    print("Animation Complete")
                } else {
                    print("Animation cancelled")
                }
            })
        }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        //            self?.animatorView.pause()
        //        }
    }
    
    
    
}
