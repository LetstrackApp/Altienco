//
//  ReviewGiftCardVC.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import FlagKit


protocol BackTOGiftCardDelegate{
    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?)
}

class ReviewGiftCardVC: UIViewController {
    var delegate: BackTOGiftCardDelegate? = nil
    var planType = 1
    var selectedFixedPlan : FixedGiftResponseObj?
    var fixedPlan : ConfirmFixedPlanViewModel?
    
    
    
    var generateVoucher : GenerateVoucherViewModel?
    
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
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryIcon: UIImageView!
    @IBOutlet weak var giftCradName: UILabel!
    
    @IBOutlet weak var denominationValue: UILabel!
    @IBOutlet weak var confirmButton: UIButton!{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bounds.origin.y = -self.view.bounds.height
        generateVoucher =  GenerateVoucherViewModel()
        fixedPlan =  ConfirmFixedPlanViewModel()
        self.setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupAlphaVC()
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
    
    func setupView(){
        if let model = selectedFixedPlan {
            self.giftCradName.text = model.operatorName
            self.denominationValue.text = (model.currencySymbol ?? "") + String(format: "%.2f", model.retailAmount ?? 0.0) + " (" +  "\(model.destinationAmount ?? 0)" + "\(model.destinationUnit ?? ""))"}
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        if selectedFixedPlan != nil{
            
            let dataModel =
            ConfirmFixedPlanRequest.init(customerID: UserDefaults.getUserData?.customerID ?? 0, mobileCode: UserDefaults.getMobileCode, mobileNumber: UserDefaults.getMobileNumber, planID: selectedFixedPlan?.planID, planName: selectedFixedPlan?.planName, planTypeID: 1, operatorID: selectedFixedPlan?.operatorID, operatorName: selectedFixedPlan?.operatorName, destinationAmount: selectedFixedPlan?.destinationAmount, destinationMaxAmount: 0, destinationMinAmount: 0, destinationUnit: selectedFixedPlan?.destinationUnit, sourceUnit: selectedFixedPlan?.sourceUnit, retailAmount: Int(selectedFixedPlan?.retailAmount ?? 0.0), retailUnit: selectedFixedPlan?.retailUnit, wholesaleAmount: selectedFixedPlan?.wholesaleAmount, wholesaleUnit: selectedFixedPlan?.wholesaleUnit, validityQuantity: "\(selectedFixedPlan?.validityQuantity ?? 0)", validityUnit: selectedFixedPlan?.validityUnit, cartItemResponseObjDescription: selectedFixedPlan?.objDescription, langCode: "en" )
    self.fixedPlan?.setFixedPlan(model: dataModel) { (result, status)  in
        DispatchQueue.main.async { [weak self] in
            self?.confirmButton.isEnabled = true
            if status == true, let data = result {
                DispatchQueue.main.async{
                    self?.dismiss(animated: false) {
                    self?.delegate?.BackToPrevious(dismiss: true, result: data)
                    }
                }
            }
        }}
    }
}
    
    @IBAction func homeBuuton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismissAlphaView()
        }
    }

}
