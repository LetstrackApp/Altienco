//
//  ReviewRangeCardVC.swift
//  Altienco
//
//  Created by Deepak on 18/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class ReviewRangeCardVC: UIViewController {
    var planType = 2
    var retailAmount = 0.0
    var countryModel : SearchCountryModel?
    var selectedRangePlan : RangeGiftCardResponse?
    var rangePlan : ConfirmRangePlanViewModel?
    var delegate: BackTOGiftCardDelegate? = nil
    
    
    
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
        generateVoucher =  GenerateVoucherViewModel()
        rangePlan =  ConfirmRangePlanViewModel()
        self.setupView()
        
    }
    
    func setupView(){
        if (self.planType == 2 || self.planType == 4),let model = self.selectedRangePlan {
            guard let retailVal = self.selectedRangePlan?.retailRates else {return}
            let destinationVal = self.calculateDestinationAmount(destinationAmount: self.retailAmount, rateRetail: retailVal)
            self.denominationValue.text = (model.currencySymbol ?? "") + " " + String(format: "%.2f", self.retailAmount) + " (\((model.destinationUnit ?? "") + destinationVal))"
            self.countryName.text = countryModel?.countryName
            self.giftCradName.text = model.operatorName
        }
    }
    
    private func calculateDestinationAmount(
            destinationAmount: Double,
            rateRetail: Double
        )-> String {
            return String(format:"%.2f", ((destinationAmount / (1 + 25 / 100)) * rateRetail))
        }
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        
        if self.selectedRangePlan != nil{
            guard let retailVal = self.selectedRangePlan?.retailRates else {return}
            let destinationVal = self.calculateDestinationAmount(destinationAmount: self.retailAmount, rateRetail: retailVal)
            let dataModel = ConfirmRangePlanRequest.init(customerID: UserDefaults.getUserData?.customerID, mobileCode: self.countryModel?.mobileCode, mobileNumber: UserDefaults.getMobileNumber , planID: self.selectedRangePlan?.planID, planName: self.selectedRangePlan?.planName, planTypeID: 2, operatorID: self.selectedRangePlan?.operatorID, operatorName: self.selectedRangePlan?.operatorName, amountWithinRetailRange: self.retailAmount, destinationAmount: destinationVal, destinationMaxAmount: self.selectedRangePlan?.destinationAmount?.max, destinationMinAmount: self.selectedRangePlan?.destinationAmount?.min, destinationUnit: self.selectedRangePlan?.destinationUnit, sourceMaxAmount: self.selectedRangePlan?.sourceAmount?.max, sourceMinAmount: self.selectedRangePlan?.sourceAmount?.min, sourceUnit: self.selectedRangePlan?.sourceUnit, retailAmount: "", retailMaxAmount: self.selectedRangePlan?.retailAmount?.max, retailMinAmount: self.selectedRangePlan?.retailAmount?.min, retailUnit: self.selectedRangePlan?.retailUnit, wholesaleAmount: "", wholesaleMaxAmount: self.selectedRangePlan?.wholesaleAmount?.max, wholesaleMinAmount: self.selectedRangePlan?.wholesaleAmount?.min, wholesaleUnit: self.selectedRangePlan?.wholesaleUnit, validityQuantity: "\(self.selectedRangePlan?.validityQuantity ?? 0)", validityUnit: self.selectedRangePlan?.validityUnit, cartItemResponseObjDescription: self.selectedRangePlan?.objDescription, langCode: "en")
           
        self.rangePlan?.setRangePlan(model: dataModel) { (result, Msg, status)   in
        DispatchQueue.main.async { [weak self] in
            self?.confirmButton.isEnabled = true
            if status == true, let data = result {
                DispatchQueue.main.async{
                    self?.dismiss(animated: false) {
                        self?.delegate?.BackToPrevious(dismiss: true, result: data)
                    }
                }
            }
            else{
                self?.showAlert(withTitle: Msg ?? "", message: "Alert")
            }
        }}
    }
}
    
    @IBAction func homeBuuton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    
    deinit {
        print("deinit");
    }
}
