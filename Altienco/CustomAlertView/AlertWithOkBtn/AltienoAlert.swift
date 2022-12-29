//
//  AltienoAlert.swift
//  Altienco
//
//  Created by mac on 22/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import Lottie

enum KindOF {
    case contactus
    case logout
    case retry
    case fail
    case profile(String)
    case other(String)
    
    var btnTitle : String {
        switch self {
        case .retry,.fail : return lngConst.try_Again.uppercased()
        default: return lngConst.ok.uppercased()
        }
    }
    
    var title : String? {
        switch self {
        case .contactus : return lngConst.shareMsgOncontactUS
        case .logout : return lngConst.logoutSuccessfully
        case .profile(let message ): return message 
        case .other(let error):
            return error
        default: return ""
        }
    }
    
    var imageName: String? {
        switch self {
        case .contactus : return "ic_other"
        case .logout : return "ic_logoutnew"
        case .retry,.fail,.profile : return nil
            
        default: return "ic_other"
        }
    }
}

class AltienoAlert: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.isHidden = false
        }
    }
    @IBOutlet weak var animator2: AnimationView! {
        didSet {
            animator2.isHidden = false
        }
    }
    @IBOutlet weak var animator: AnimationView!
    @IBOutlet weak var imageSection: UIView!
    
    // MARK:- Private Properties
    private var kind : KindOF?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK:- Public Properties
    @IBOutlet private var viewAlert: UIView!
    @IBOutlet  var lblAlertText: PaddingLabel?{
        didSet{
            lblAlertText?.font = UIFont.SF_Regular(15)
        }
    }
    @IBOutlet private var btnOK: UIButton!{
        didSet{
            btnOK.setupNextButton(title: lngConst.ok.uppercased())
            btnOK.titleLabel?.font = UIFont.SF_Regular(15)
            btnOK.addTarget(self, action: #selector(btnOkTapped(_:)), for: .touchUpInside)
            
        }
    }
    
    /// AlertController Completion handler
    typealias alertCompletionBlock = ((Int, String) -> Void)?
    private var block : alertCompletionBlock?
    
    // MARK:- LTCustomAlertVC Initialization
    
    /**
     Creates a instance for using AlertController
     - returns: LTCustomAlertVC
     */
    static func initialization() -> AltienoAlert{
        let alertController = AltienoAlert(nibName: xibName.altienoAlert, bundle: nil)
        return alertController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLTCustomAlertVC()
    }
    
    // MARK:- LTCustomAlertVC Private Functions
    /// Initial View Setup
    private func setupLTCustomAlertVC(){
        //        viewAlert.translatesAutoresizingMaskIntoConstraints = false
        viewAlert.layer.shadowColor = UIColor.black.cgColor
        viewAlert.layer.shadowRadius = 5
        viewAlert.layer.shadowOpacity = 0.4
        viewAlert.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewAlert.layer.cornerRadius = 10
        lblAlertText?.text = kind?.title
        lblAlertText?.textAlignment = .center
        btnOK.setTitle(lngConst.ok.uppercased(), for: .normal)
        btnOK.setTitleColor(.white, for: .normal)
        
        if let image  = kind?.imageName {
            imageView.image = UIImage(named: image)
        }
        
    }
    
    
    func animateView() {
        let animation = Animation.named("circle_animation")
        animator.animation = animation
        animator.contentMode = .scaleAspectFit
        animator.backgroundBehavior = .pauseAndRestore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            Helper.shared.playSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              
                if  self?.kind?.imageName  != nil{
                    self?.opupInAniamtion()
                }else {
                    self?.showAnimateSecond()
                }
            }
            
            self?.animator.play(fromProgress: 0,
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
    
    func showAnimateSecond() {
        animator2.isHidden = false
        var animation: Animation?
        switch kind {
        case .profile:
            animation = Animation.named("thumbs_up")
        default:
            animation = Animation.named("alert")
        }
        
        animator2.animation = animation
        animator2.contentMode = .scaleAspectFit
        animator2.backgroundBehavior = .pauseAndRestore
        
        animator2.play(fromProgress: 0,
                       toProgress: 1,
                       loopMode: LottieLoopMode.loop,
                       completion: { (finished) in
            if finished {
                
                print("Animation Complete")
            } else {
                print("Animation cancelled")
            }
        })
        
    }
    
    func opupInAniamtion(){
        self.animator2.isHidden = true
        imageView.isHidden = false
        self.imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    /// Setup different widths for iPad and iPhone
    
    
    
    
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
            view.frame = topViewController.view.bounds
            self.bottomConstraint.constant = -getBottomConstant()
            self.view.backgroundColor = UIColor.clear
            self.animateView()
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
    
    
    func getBottomConstant ()->CGFloat{
        let alertViewHeight = viewAlert.bounds.size.height
        let totalHeight = (alertViewHeight +  (viewAlert.bounds.origin.y))
        let viewHeight = UIScreen.main.bounds.height
        let bottomDistace = (viewHeight - totalHeight) + alertViewHeight
        return bottomDistace
    }
    /// Hide Alert Controller
    private func hide(completion:@escaping(Bool)->Void){
        self.view.endEditing(true)
        Helper.shared.isAlertShown = false
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
    
    // MARK:- UIButton Clicks
    @IBAction func btnOkTapped(_ sender: UIButton) {
        
        hide { _ in
            self.block??(0,(sender.titleLabel?.text ?? ""))
        }
    }
    
    //
    //
    //
    //    /// Hide Alert Controller on background tap
    //    @objc func backgroundViewTapped(sender:AnyObject){
    //        hide()
    //    }
    
    /// Display Alert
    /// - Parameters:
    ///   - model: model to setup View
    ///   - completion: retuen the index or title of the button
    public func showAlert(with kind : KindOF?,
                          completion : alertCompletionBlock) {
        Helper.shared.isAlertShown = true
        self.kind = kind
        show()
        block = completion
    }
    
    
    
}
