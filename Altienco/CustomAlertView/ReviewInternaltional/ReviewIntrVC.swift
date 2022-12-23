//
//  ReviewIntrVC.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class ReviewIntrVC: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //    var delegate: BackTOGiftCardDelegate? = nil
    private var countryModel : SearchCountryModel? = nil
    private var selectedOperator : OperatorList? = nil
    private var planHistoryResponse: [LastRecharge]? = []
    private var mobileNumberValue : String?
    private var viewModel : ConfirmIntrViewModel?
    
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var mobileView: UIView!{
        didSet {
            mobileView.isHidden = true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var denominationValue: UILabel!
    @IBOutlet weak var confirmButton: LoadingButton!{
        didSet{
            self.confirmButton.setupNextButton(title: "CONFIRM RECHARGE")
        }
    }
    @IBOutlet weak var editButton: UIButton!{
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    typealias alertCompletionBlock = ((ConfirmIntrResponseObj?,Bool) -> Void)?
    private var block : alertCompletionBlock?
    
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        if planHistoryResponse?.isEmpty == false{
            let planValue = planHistoryResponse?.first
            let dataModel = ConfirmIntrRequestObj.init(customerID: UserDefaults.getUserData?.customerID ?? 0,
                                                       mobileCode: self.countryModel?.mobileCode,
                                                       mobileNumber: self.mobileNumberValue,
                                                       planID: planValue?.planID,
                                                       destinationUnit: planValue?.destinationUnit,
                                                       retailAmount: planValue?.retailAmount ?? 0.0,
                                                       destinationAmount: planValue?.destinationAmount ?? 0.0,
                                                       wholesaleAmount: planValue?.wholesaleAmount,
                                                       retailUnit: planValue?.retailUnit,
                                                       validityQuantity: "\(planValue?.validityQuantity ?? 0)",
                                                       wholesaleUnit: planValue?.wholesaleUnit,
                                                       validityUnit: planValue?.validityUnit,
                                                       cartItemResponseObjDescription: planValue?.lastRechargeDescription,
                                                       data: planValue?.data,
                                                       langCode: "en")
            self.confirmButton.showLoading()
            self.view.isUserInteractionEnabled = false
            self.viewModel?.confirmRecharge(model: dataModel) { (result, status)  in
                DispatchQueue.main.async { [weak self] in
                    self?.confirmButton.isEnabled = true
                    self?.confirmButton.hideLoading()
                    self?.view.isUserInteractionEnabled = true
                    if status == true, let data = result {
                        DispatchQueue.main.async{
                            self?.hide { _ in
                                self?.block??(data,true)
                            }
                           
                        }
                    }
                }
            }}
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
        viewModel =  ConfirmIntrViewModel()
        
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
    
    func setupView(){
        
        if  let mobile = mobileNumberValue {
            mobileNumber.text = mobile
            mobileView.isHidden = false
        }else {
            mobileView.isHidden = true
        }
        
        var validity = "0.0"
        if self.planHistoryResponse?.isEmpty == false{
            if let operatorTitle = self.selectedOperator?.operatorName{
                self.operatorName.text = operatorTitle
            }
            if let destinationAmount = self.planHistoryResponse?.first?.destinationAmount, let destinationUnit = self.planHistoryResponse?.first?.destinationUnit{
                if let sourceAmount = self.planHistoryResponse?.first?.retailAmount, let sourceUnit = self.planHistoryResponse?.first?.retailUnit{
                    validity = "\(destinationAmount) \(destinationUnit) (\(String(format: "%.2f", sourceAmount))\(sourceUnit))"
                }
                self.denominationValue.text = validity
            }}
    }
    
    
    public func showAlert(usingModel planHistoryResponse: [LastRecharge]?,
                          countryModel: SearchCountryModel?,
                          selectedOperator: OperatorList?,
                          mobileNumberValue: String?,
                          completion: alertCompletionBlock){
        self.planHistoryResponse = planHistoryResponse
        self.countryModel = countryModel
        self.selectedOperator = selectedOperator
        self.planHistoryResponse = planHistoryResponse
        self.mobileNumberValue = mobileNumberValue
        show()
        block = completion
    }
    
    
    
    
}

