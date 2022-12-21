//
//  FloatingPannelHelper.swift
//  Altienco
//
//  Created by mac on 20/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

import FloatingPanel

class FloatingPannelHelper: UIViewController,FloatingPanelControllerDelegate {
    
    private var reviewPopup: FloatingPanelController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupReviewPopup(){
        if reviewPopup == nil {
            reviewPopup = FloatingPanelController()
            reviewPopup.surfaceView.backgroundColor = .clear
            reviewPopup.behavior = FloatingPanelStocksBehavior()
            reviewPopup.surfaceView.grabberHandle.isHidden = true
            // Initialize FloatingPanelController and add the view
            reviewPopup.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0,
                                                              green: 30.0/255.0,
                                                              blue: 30.0/255.0,
                                                              alpha: 1.0)
            reviewPopup.surfaceView.appearance.cornerRadius = 8
            let shadow = SurfaceAppearance.Shadow()
            shadow.color = UIColor.black
            shadow.offset = CGSize(width: 0, height: 0)
            shadow.radius = 8
            shadow.spread = 2
            reviewPopup.surfaceView.appearance.shadows = [shadow]
            reviewPopup.surfaceView.appearance.borderWidth = 1.0 / traitCollection.displayScale
            reviewPopup.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
            reviewPopup?.surfaceView.containerMargins = .init(top: 30.0, left: 20, bottom: -100, right: 20)
            let viewControler = ReviewPopupVC()
            reviewPopup.set(contentViewController: viewControler)
            reviewPopup.contentMode = .fitToBounds
            reviewPopup.isRemovalInteractionEnabled = false
            reviewPopup.delegate = self
        }
        present(reviewPopup, animated: true, completion: nil)
        
        
    }
    
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        if vc.contentViewController?.isKind(of: ReviewPopupVC.self) == true{
            return TopPositionedPanelLayout()
        }
        return TopPositionedPanelLayout()
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController){

    }
    
}

class FloatingPanelStocksBehavior: FloatingPanelBehavior {
    let springDecelerationRate: CGFloat = UIScrollView.DecelerationRate.fast.rawValue
    let springResponseTime: CGFloat = 0.25
}


class TopPositionedPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(fractionalInset: 1, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 1, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 1, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
