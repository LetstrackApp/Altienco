//
//  ReviewPopupVC.swift
//  Altienco
//
//  Created by Ashish on 05/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

protocol BackToUKRechargeDelegate{
    func BackToPrevious(status: Bool, result: GenerateVoucherResponseObj?)
}

class ReviewPopupVC: UIViewController {
     var mobileNumber : String?
    var operatorID = 0
    var denomination = 0
    var operatorTitle = ""
    var planName = ""
    var currency = ""
    var isEdit = false
    var delegate: BackToUKRechargeDelegate? = nil
    var generateVoucher : GenerateVoucherViewModel?
    
    @IBOutlet weak var mobileNumberVIew: UIView!{
        didSet {
            mobileNumberVIew.isHidden = true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.layer.cornerRadius = 8
        }
    }
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
                self.confirmButton.setupNextButton(title: "CONFIRM ORDER")
        }
    }
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mobileNumTitle: UILabel! {
        didSet {
            mobileNumTitle.text = "Mobile Number"
        }
    }
    
    @IBOutlet weak var mobileNumValue: UILabel!
    
    convenience init() {
        self.init(nibName: xibName.reviewPopupVC, bundle: .altiencoBundle)
        generateVoucher =  GenerateVoucherViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setupView()
    }
    
    
    
    
    
    @IBAction func confirmOrder(_ sender: Any) {
        self.confirmButton.isEnabled = false
        self.operatorTitle = self.operatorTitle.replacingOccurrences(of: " ", with: "")
        let dataModel = GenerateVoucherModel.init(customerID: "\(UserDefaults.getUserData?.customerID ?? 0)",
                                                  operatorID: "\(self.operatorID)",
                                                  planName: self.planName,
                                                  currency: UserDefaults.getUserData?.currencySymbol ?? "" , dinominationValue: "\(denomination)",
                                                  langCode: "en",
                                                  transactionTypeId: TransactionTypeId.PhoneRecharge.rawValue)
        self.generateVoucher?.generateVoucher(model: dataModel) { (result,status,msg)   in
            if status == false && msg != ""{
                self.alert(message: msg ?? "", title: "Alert")
            }
            else{
            DispatchQueue.main.async { [weak self] in
                self?.confirmButton.isEnabled = true
                if result != nil, let data = result{
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
        editButton.setTitle((isEdit == true ? "EDIT ORDER" : "CLOSE") , for: .normal)
        self.operatorName.text = operatorTitle
        self.denominationValue.text = currency + "\(denomination)"
        if let mobile = mobileNumber {
            mobileNumValue.text = mobile
            mobileNumberVIew.isHidden = false
        }else {
            mobileNumberVIew.isHidden = true
        }
    }

}
