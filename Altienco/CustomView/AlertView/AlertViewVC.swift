//
//  AlertViewVC.swift
//  Altienco
//
//  Created by mac on 17/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

enum AlertTypes<T> {
    case transactionSucessfull(amount : T)
}

final class AlertViewVC: UIViewController {
    
    var alertTypes : AlertTypes<Any>?
    
    var onCompletion: (()->())?
    
    private var bottom :  NSLayoutConstraint?
    
    lazy private var bgbutton : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(viewDismiss(_ :)), for: .touchUpInside)
        return btn
    }()
    
    lazy private  var txnSucess : TransactionSuccessFull = {
        let control = TransactionSuccessFull.loadFromNib(from: .altiencoBundle)
        return control
    }()
    
    
    convenience init(type : AlertTypes<Any>) {
        self.init()
        self.alertTypes = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            switch self?.alertTypes {
            case .transactionSucessfull(let amount):
                if let currencySymbol = UserDefaults.getUserData?.currencySymbol{
                    let value = "\(currencySymbol)\(amount)"
                    self?.txnSucess.configure(with: value) { [weak self] result in
                        self?.dismissView()
                    }
                }
                self?.setupTXNSucessView()
            default:break
            }
        }
    }
    
    private func setupTXNSucessView(){
        addConstraint(subView: txnSucess, height: 445)
    }
    
    @IBAction private func viewDismiss(_ sender : UIButton) {
        switch alertTypes {
        case .transactionSucessfull:
            break
        default: dismissView()
        }
       
    }
    
    private func dismissView(){
        self.bottom?.constant = 500
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: []) {[weak self] in
            self?.view.backgroundColor = UIColor.clear
            self?.view.layoutIfNeeded()
            switch self?.alertTypes {
            case .transactionSucessfull:self?.txnSucess.layoutIfNeeded()
            default:break
            }
        } completion: { [weak self] (result) in
            self?.dismiss(animated: false) {
                switch self?.alertTypes{
                case .transactionSucessfull:
                    self?.onCompletion?()
                default: break
                }
            }
        }
    }
    
    private func addConstraint<T : UIView>(subView : T,height:CGFloat){
        
        subView.frame = CGRect(x: 10,
                               y: UIScreen.height,
                               width: UIScreen.width - 20,
                               height: height)
        [bgbutton,subView].forEach{ view.addSubview($0)}
        
        bgbutton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        subView.translatesAutoresizingMaskIntoConstraints = false
        bottom =  subView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                  constant: UIScreen.height)
        bottom?.isActive = true
        subView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subView.widthAnchor.constraint(equalToConstant: UIScreen.width - 20).isActive = true
        subView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        DispatchQueue.main.asyncAfter(deadline: Dispatch.DispatchTime.now() + 0.1) { [weak self] in
            self?.bottom?.constant = 0
            UIView.animate(withDuration: 1) {
                self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
        
        
        
    }
    
    
    
    
    deinit {
        debugPrint("deinit")
    }
    
    
}
