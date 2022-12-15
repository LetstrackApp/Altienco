//
//  ReviewIntrVC.swift
//  Altienco
//
//  Created by Ashish on 30/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class ReviewIntrVC: UIViewController {

    var delegate: BackTOGiftCardDelegate? = nil
    var countryModel : SearchCountryModel? = nil
    var selectedOperator : OperatorList? = nil
    var planHistoryResponse: [LastRecharge]? = []
    var mobileNumber : String?
    
    var recharge : ConfirmIntrViewModel?
    
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
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            DispatchQueue.main.async {
                self.confirmButton.setupNextButton(title: "CONFIRM RECHARGE")
            }
        }
    }
    @IBOutlet weak var editButton: UIButton!{
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recharge =  ConfirmIntrViewModel()
        self.setupView()
    }
    
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        if planHistoryResponse?.isEmpty == false{
            let dataModel = ConfirmIntrRequestObj.init(customerID: UserDefaults.getUserData?.customerID ?? 0, mobileCode: self.countryModel?.mobileCode, mobileNumber: self.mobileNumber, planID: planHistoryResponse?.first?.planID, destinationUnit: planHistoryResponse?.first?.destinationUnit, retailAmount: planHistoryResponse?.first?.retailAmount ?? 0.0, destinationAmount: planHistoryResponse?.first?.destinationAmount ?? 0.0, wholesaleAmount: planHistoryResponse?.first?.wholesaleAmount, retailUnit: planHistoryResponse?.first?.retailUnit, validityQuantity: "\(planHistoryResponse?.first?.validityQuantity ?? 0)", wholesaleUnit: planHistoryResponse?.first?.wholesaleUnit, validityUnit: planHistoryResponse?.first?.validityUnit, cartItemResponseObjDescription: planHistoryResponse?.first?.lastRechargeDescription, data: planHistoryResponse?.first?.data, langCode: "en")
        self.recharge?.confirmRecharge(model: dataModel) { (result, status)  in
            DispatchQueue.main.async { [weak self] in
                self?.confirmButton.isEnabled = true
                if status == true, let data = result {
                    DispatchQueue.main.async{
                        self?.dismiss(animated: false) {
                            self?.delegate?.BackToPrevious(dismiss: true, result: data)
                        }
                    }
                }
        }
        }}
}
    
    @IBAction func homeBuuton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func setupView(){
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

  
    
//    public func showAlert(usingModel mobileNumber : String, countryModel : SearchCountryModel?,selectedOperator : OperatorList,planHistoryResponse: [LastRecharge], completion : alertCompletionBlock){
//        self.countryModel = countryModel
//        self.selectedOperator = selectedOperator
//        self.planHistoryResponse = planHistoryResponse
//        self.mobileNumber = mobileNumber
//        show()
//        block = completion
//    }
//
//    deinit {
//        print("deinit");
//    }
}

