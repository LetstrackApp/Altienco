//
//  CallingCardReviewVC.swift
//  Altienco
//
//  Created by Deepak on 06/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class CallingCardReviewVC: UIViewController {

    var operatorID = 0
    var denomination = 0
    var operatorTitle = ""
    var planName = ""
    var currency = ""
    var isEdit = false
    var delegate: BackToUKRechargeDelegate? = nil
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
    @IBOutlet weak var editText: UILabel!
    @IBOutlet weak var operatorName: UILabel!
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
        self.setupView()
    }
   
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        self.operatorTitle = self.operatorTitle.replacingOccurrences(of: " ", with: "")
        let dataModel = GenerateVoucherModel.init(customerID: "\(UserDefaults.getUserData?.customerID ?? 0)", operatorID: "\(self.operatorID)", planName: self.planName, currency: UserDefaults.getUserData?.currencySymbol ?? "" , dinominationValue: "\(denomination)", langCode: "en", transactionTypeId: TransactionTypeId.CallingCard.rawValue)
        self.generateVoucher?.generateVoucher(model: dataModel) { (result,status,msg)   in
            if status == false && msg != ""{
                self.alert(message: msg ?? "", title: "Alert")
            }
            else{
            DispatchQueue.main.async { [weak self] in
                self?.confirmButton.isEnabled = true
                if status == true, let data = result{
                    DispatchQueue.main.async{
                        self?.dismiss(animated: false) {
                            self?.delegate?.BackToPrevious(status: true, result: data)
                        }
                    }
                }
            }
        }
        }
}
    
    @IBAction func homeBuuton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func setupView(){
        isEdit == true ? (self.editText.text = "EDIT ORDER") : (self.editText.text = "CLOSE")
        self.operatorName.text = operatorTitle
        self.denominationValue.text = currency + "\(denomination)"
    }
}
