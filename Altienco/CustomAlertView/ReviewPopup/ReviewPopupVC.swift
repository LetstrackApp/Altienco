//
//  ReviewPopupVC.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
//TransactionTypeId.PhoneRecharge.rawValue
import Lottie
struct ReviewPopupModel {
    var mobileNumber : String?
    var operatorID :Int = 0
    var denomination: Int = 0
    var operatorTitle : String = ""
    var planName:String = ""
    var currency:String = ""
    var isEdit :Bool = false
    var transactionTypeId:Int?
    
    init(mobileNumber : String?,
         operatorID :Int,
         denomination: Int,
         operatorTitle : String,
         planName:String,
         currency:String,
         isEdit :Bool,
         transactionTypeId: Int){
        self.mobileNumber = mobileNumber
        self.operatorID = operatorID
        self.denomination = denomination
        self.operatorTitle = operatorTitle
        self.planName = planName
        self.currency = currency
        self.isEdit = isEdit
        self.transactionTypeId = transactionTypeId
    }
}



class ReviewPopupVC: UIViewController {
    
    var reviewPopupModel : ReviewPopupModel?
    var generateVoucher : GenerateVoucherViewModel?
    
    var fixedPlan : ConfirmFixedPlanViewModel?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.isHidden = true
        }
        
    }
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberVIew: UIView!{
        didSet {
            mobileNumberVIew.isHidden = true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.layer.cornerRadius = 10
        }
    }
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
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var denominationValue: UILabel!
    @IBOutlet weak var confirmButton: LoadingButton!{
        didSet{
            self.confirmButton.setupNextButton(title: "CONFIRM ORDER")
        }
    }
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mobileNumTitle: UILabel! {
        didSet {
            mobileNumTitle.text = "Mobile Number"
        }
    }
    
    @IBOutlet weak var mobileNumValue: UILabel!
    
    /// AlertController Completion handler
    typealias alertCompletionBlock = ((GenerateVoucherResponseObj?,Bool) -> Void)?
    private var block : alertCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    
    
    
    static func initialization() -> ReviewPopupVC {
        let alertController = ReviewPopupVC(nibName: xibName.reviewPopupVC, bundle: nil)
        return alertController
    }
    /// Show Alert Controller
    private func show(){
        self.generateVoucher = GenerateVoucherViewModel()
        
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
            self.setupView()
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
    
    /// Hide Alert Controller
    private func hide(completion:@escaping(Bool)->Void) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
            self?.bottomConstraint?.constant = -(self?.getBottomConstant() ?? 0)
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                self?.scrollView.alpha = 0.0
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
    
    
    
    func animateView() {
        let animation = Animation.named("circle_animation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            Helper.shared.playSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               
                self?.opupInAniamtion()
            }
            
            self?.animationView.play(fromProgress: 0,
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
    
    func opupInAniamtion(){
        imageView.isHidden = false
        self.imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func getBottomConstant ()->CGFloat{
        let alertViewHeight = scrollView.bounds.size.height
        let totalHeight = (alertViewHeight +  (scrollView.bounds.origin.y))
        let viewHeight = UIScreen.main.bounds.height
        let bottomDistace = (viewHeight - totalHeight) + alertViewHeight
        return bottomDistace
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        //        self.operatorTitle = reviewPopupModel?.operatorTitle.replacingOccurrences(of: " ", with: "").trimWhite.shoSpace
        self.confirmButton.showLoading()
        self.view.isUserInteractionEnabled = false
        
        let dataModel = GenerateVoucherModel.init(customerID: "\(UserDefaults.getUserData?.customerID ?? 0)",
                                                  operatorID: "\(self.reviewPopupModel?.operatorID ?? 0)",
                                                  planName: self.reviewPopupModel?.planName ?? "",
                                                  currency: UserDefaults.getUserData?.currencySymbol ?? "" , dinominationValue: "\(self.reviewPopupModel?.denomination ?? 0)",
                                                  langCode: "en",
                                                  transactionTypeId: self.reviewPopupModel?.transactionTypeId ?? 0)
        
        self.generateVoucher?.generateVoucher(model: dataModel) { (result,status,msg)   in
            DispatchQueue.main.async { [weak self] in
                self?.confirmButton.hideLoading()
                self?.view.isUserInteractionEnabled = true
                if status == false {
                    Helper.showToast(msg, isAlertView: true)
                }
                else{
                    if let data = result {
                        self?.hide {_ in
                            self?.block??(data,true)
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func homeBuuton(_ sender: Any) {
        hide{_ in        }
    }
    
    func setupView(){
        editButton.setTitle((reviewPopupModel?.isEdit == true ? "EDIT ORDER" : "CLOSE") , for: .normal)
        self.operatorName.text = reviewPopupModel?.operatorTitle
        self.denominationValue.text = (reviewPopupModel?.currency ?? "") + "\(reviewPopupModel?.denomination ?? 0)"
        if let mobile = reviewPopupModel?.mobileNumber {
            mobileNumValue.text = mobile
            mobileNumberVIew.isHidden = false
        }else {
            mobileNumberVIew.isHidden = true
        }
    }
    
    
    /// Display Alert
    /// - Parameters:
    ///   - model: model to setup View
    ///   - completion: retuen the index or title of the button
    public func showAlert(usingModel reviewPopupModel : ReviewPopupModel?,
                          completion : alertCompletionBlock){
        self.reviewPopupModel = reviewPopupModel
        show()
        block = completion
    }
    
    
}



