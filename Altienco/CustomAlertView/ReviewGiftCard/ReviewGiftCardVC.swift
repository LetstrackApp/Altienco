//
//  ReviewGiftCardVC.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import FlagKit
import Lottie

protocol BackTOGiftCardDelegate{
    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?)
}

class ReviewGiftCardVC: UIViewController {
    //    var delegate: BackTOGiftCardDelegate? = nil
    private var planType = 1
    private var selectedFixedPlan : FixedGiftResponseObj?
    var fixedPlan : ConfirmFixedPlanViewModel?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.isHidden = true
        }
        
    }
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.layer.cornerRadius = 10
        }
    }
    
    private var viewModel : GenerateVoucherViewModel?
    
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryIcon: UIImageView!
    @IBOutlet weak var giftCradName: UILabel!
    
    @IBOutlet weak var denominationValue: UILabel!
    @IBOutlet weak var confirmButton: LoadingButton!{
        didSet{
            DispatchQueue.main.async {
                self.confirmButton.setupNextButton(title: "CONFIRM ORDER")
            }
        }
    }
    @IBOutlet weak var editButton: UIButton!{
        didSet{
        }
    }
    
    typealias alertCompletionBlock = ((ConfirmIntrResponseObj?,Bool) -> Void)?
    private var block : alertCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel =  GenerateVoucherViewModel()
        fixedPlan =  ConfirmFixedPlanViewModel()
        self.setupView()
       
        
    }
    
  
    
    func setupFlag(countryCode: String, isUpdate: Bool){
        if isUpdate == true{
            let flag = Flag(countryCode: countryCode)
            let originalImage = flag?.originalImage
            countryIcon.image = originalImage
        }
        else{
            let flag = Flag(countryCode: countryCode)
            let originalImage = flag?.originalImage
            countryIcon.image = originalImage
        }
    }
    
    
    static func initialization() -> ReviewGiftCardVC {
        let alertController = ReviewGiftCardVC(nibName: xibName.reviewGiftCardVC, bundle: nil)
        return alertController
    }
    func setupView(){
        if let model = selectedFixedPlan {
            self.giftCradName.text = model.operatorName
            self.denominationValue.text = (model.currencySymbol ?? "") + String(format: "%.2f", model.retailAmount ?? 0.0) + " (" +  "\(model.destinationAmount ?? 0)" + "\(model.destinationUnit ?? ""))"}
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        if selectedFixedPlan != nil{
            let dataModel =
            ConfirmFixedPlanRequest.init(customerID: UserDefaults.getUserData?.customerID ?? 0,
                                         mobileCode: UserDefaults.getMobileCode,
                                         mobileNumber: UserDefaults.getMobileNumber,
                                         planID: selectedFixedPlan?.planID,
                                         planName: selectedFixedPlan?.planName,
                                         planTypeID: 1,
                                         operatorID: selectedFixedPlan?.operatorID,
                                         operatorName: selectedFixedPlan?.operatorName,
                                         destinationAmount: selectedFixedPlan?.destinationAmount,
                                         destinationMaxAmount: 0,
                                         destinationMinAmount: 0,
                                         destinationUnit: selectedFixedPlan?.destinationUnit,
                                         sourceUnit: selectedFixedPlan?.sourceUnit,
                                         retailAmount: Int(selectedFixedPlan?.retailAmount ?? 0.0),
                                         retailUnit: selectedFixedPlan?.retailUnit,
                                         wholesaleAmount: selectedFixedPlan?.wholesaleAmount,
                                         wholesaleUnit: selectedFixedPlan?.wholesaleUnit,
                                         validityQuantity: "\(selectedFixedPlan?.validityQuantity ?? 0)",
                                         validityUnit: selectedFixedPlan?.validityUnit,
                                         cartItemResponseObjDescription: selectedFixedPlan?.objDescription,
                                         langCode: "en" )
            
            self.confirmButton.showLoading()
            self.view.isUserInteractionEnabled = false
            self.fixedPlan?.setFixedPlan(model: dataModel) { (result, status)  in
                DispatchQueue.main.async { [weak self] in
                    self?.confirmButton.hideLoading()
                    self?.view.isUserInteractionEnabled = true
                    self?.confirmButton.isEnabled = true
                    if status == true, let data = result {
                        DispatchQueue.main.async{
                            self?.hide{_ in
                                self?.block??(data,true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getBottomConstant ()->CGFloat{
        let alertViewHeight = scrollView.bounds.size.height
        let totalHeight = (alertViewHeight +  (scrollView.bounds.origin.y))
        let viewHeight = UIScreen.main.bounds.height
        let bottomDistace = (viewHeight - totalHeight) + alertViewHeight
        return bottomDistace
    }
    
    
    static func initialization() -> ReviewIntrVC {
        let alertController = ReviewIntrVC(nibName: xibName.reviewIntrVC, bundle: nil)
        return alertController
    }
    /// Show Alert Controller
    private func show(){
        viewModel =  GenerateVoucherViewModel()
        fixedPlan =  ConfirmFixedPlanViewModel()
        
        
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
            //            self.setupView()
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
    
    func animateView() {
        let animation = Animation.named("circle_animation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            Helper.shared.playSound(kind: .reviewPop)
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
    
    /// Hide Alert Controller
    private func hide(completion:@escaping(Bool)->Void){
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
    
    
    @IBAction func homeBuuton(_ sender: Any) {
        hide{ _ in}
    }
    
    
    public func showAlert(usingModel selectedFixedPlan: FixedGiftResponseObj?,
                          planType: Int,
                          completion: alertCompletionBlock){
        self.planType = planType
        self.selectedFixedPlan = selectedFixedPlan
        show()
        block = completion
    }
    
}
