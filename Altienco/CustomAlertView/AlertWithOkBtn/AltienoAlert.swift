//
//  AltienoAlert.swift
//  Altienco
//
//  Created by mac on 22/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AltienoAlert: UIViewController {
    // MARK:- Private Properties
    private var alertTitle : String?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK:- Public Properties
    @IBOutlet private var viewAlert: UIView!
    @IBOutlet private var lblAlertText: PaddingLabel?{
        didSet{
            lblAlertText?.font = UIFont.SF_Regular(15)
        }
    }
    @IBOutlet private var btnOK: UIButton!{
        didSet{
            btnOK.setupNextButton(title: lngConst.ok.uppercased(),cornerRadius: 10)
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
        viewAlert.layer.cornerRadius = 4
        lblAlertText?.text = alertTitle
        lblAlertText?.textAlignment = .center
        btnOK.setTitle(lngConst.ok.uppercased(), for: .normal)
        btnOK.setTitleColor(.white, for: .normal)
    }
    
    /// Setup different widths for iPad and iPhone
    
    
    /// Create and Configure Alert Controller
    private func configure(title : String?) {
        self.alertTitle = title
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
            view.frame = topViewController.view.bounds
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
    public func showAlert(with title : String?,
                          completion : alertCompletionBlock){
        configure(title: title)
        show()
        block = completion
    }
    
    
    
}
