//
//  FloatingPannelHelper.swift
//  Altienco
//
//  Created by mac on 20/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SkeletonView
import FloatingPanel

class FloatingPannelHelper: UIViewController,FloatingPanelControllerDelegate {
    
    private var recentTxn: FloatingPanelController!
    var viewControler : RecentTXNVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupRecentTxn(txnTypeId: TransactionTypeId?,completion:@escaping(Bool)-> Void) {
        if recentTxn == nil {
            recentTxn = FloatingPanelController()
            recentTxn?.backdropView.dismissalTapGestureRecognizer.isEnabled = true
            recentTxn?.surfaceView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            recentTxn?.behavior = FloatingPanelStocksBehavior()
            recentTxn?.surfaceView.grabberHandle.isHidden = false
            // Initialize FloatingPanelController and add the view
            recentTxn?.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
            recentTxn?.surfaceView.appearance.cornerRadius = 8
            let shadow = SurfaceAppearance.Shadow()
            shadow.color = UIColor.black
            shadow.offset = CGSize(width: 0, height: 0)
            shadow.radius = 8
            shadow.spread = 2
            recentTxn?.surfaceView.appearance.shadows = [shadow]
            recentTxn?.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
            recentTxn?.surfaceView.appearance.borderColor = UIColor.black
            recentTxn?.surfaceView.containerMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
            viewControler = RecentTXNVC(txnType: txnTypeId)
            viewControler?.didSelectDone = { result in
                DispatchQueue.main.async {
                    self.successVoucher(mPin: result.mPIN ?? "",
                                        denominationValue: "\(result.dinominationValue ?? 0)",
                                        walletBalance: result.walletAmount ?? 0.0,
                                        msgToShare: result.msgToShare ?? "",
                                        voucherID: result.voucherID ?? 0,
                                        orderNumber: "")
                }
            }
            recentTxn?.set(contentViewController: viewControler)
            
            if let sc = viewControler?.tableview {
                recentTxn?.track(scrollView: sc)
            }
            recentTxn?.contentMode = .fitToBounds
            recentTxn?.isRemovalInteractionEnabled = true
            recentTxn?.delegate = self
            
        }
        if  let fcb = recentTxn {
            recentTxn.view.isSkeletonable = true
            recentTxn.contentViewController?.view.isSkeletonable = true
            
            recentTxn.contentViewController?.view.subviews.forEach({ view in
                view.isSkeletonable = true
            })
            
            viewControler?.getRecentFiveTxn { result in
                completion(result)
                DispatchQueue.main.async {
                    if result == true {
                        self.present(fcb, animated: true, completion: nil)
                        
                    }else {
                        Helper.showToast("Record not found!")
                    }
                }
            }
        }
        
        
    }
    
    
    func successVoucher(mPin: String,
                        denominationValue : String,
                        walletBalance: Double,
                        msgToShare: String,
                        voucherID: Int,
                        orderNumber:String){
        
        self.recentTxn.dismiss(animated: true) {
            DispatchQueue.main.async {
                let viewController: SuccessRechargeVC = SuccessRechargeVC()
                viewController.denominationValue = denominationValue
                viewController.mPin = mPin
                viewController.walletBal = walletBalance
                viewController.voucherID = voucherID
                viewController.msgToShare = msgToShare
                viewController.orderNumber = orderNumber
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        
        
    }
    
    
    
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        if vc.contentViewController?.isKind(of: RecentTXNVC.self) == true{
            return TopPositionedPanelLayout()
        }
        return TopPositionedPanelLayout()
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController){
        
    }
    
}

class FloatingPanelStocksBehavior: FloatingPanelBehavior {
    let springDecelerationRate: CGFloat = UIScrollView.DecelerationRate.fast.rawValue
    let springResponseTime: CGFloat = 0.2
}

class TopPositionedPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(fractionalInset: 1, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 400/UIScreen.main.bounds.size.height, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 200, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.6
    }
}

