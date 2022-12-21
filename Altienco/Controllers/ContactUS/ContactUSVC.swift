//
//  ContactUSVC.swift
//  Altienco
//
//  Created by mac on 21/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import DropDown
import StripePaymentsUI

class ContactUSVC: UIViewController {
    lazy  var dropDown : DropDown = {
        let drop = DropDown()
        drop.direction = .any
        return drop
    }()
    
    @IBOutlet weak var line: UIView!{
        didSet {
            line.roundFromTop(radius: 8)
        }
    }
    @IBOutlet weak var scrolview: UIScrollView! {
        didSet {
            scrolview.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var viewDiscription: UILabel! {
        didSet {
            viewDiscription.text = lngConst.reasonDes
            viewDiscription.font = UIFont.SFPro_Light(13)
        }
    }
    @IBOutlet weak var viewTitle: UILabel!{
        didSet {
            viewTitle.text = lngConst.reasonTitle
            viewTitle.font = UIFont.SF_Medium(16)
            
        }
    }
    @IBOutlet weak var reasionView: UIView!{
        didSet {
            reasionView.layer.cornerRadius = 8
            reasionView.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            reasionView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var email: UITextField! {
        didSet {
            email.font = UIFont.SF_Regular(14)
            email.delegate = self
            email.placeholder = lngConst.email
            
        }
    }
    @IBOutlet weak var mobile: UITextField!{
        didSet {
            mobile.font = UIFont.SF_Regular(14)
            mobile.placeholder = lngConst.mobile
            mobile.delegate = self
            
            
        }
    }
    @IBOutlet weak var resion: UIView!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var resionBtm: LoadingButton!{
        didSet {
            resionBtm.setTitle(lngConst.reason, for: .normal)
            resionBtm.titleLabel?.font = UIFont.SF_Regular(14)
            resionBtm.addTarget(self, action: #selector(getReasonValues(_:)), for: .touchUpInside)
            
        }
    }
    @IBOutlet weak var attachmentBtn: UIButton! {
        didSet {
            attachmentBtn.setTitle(lngConst.addAttachments, for: .normal)
        }
    }
    @IBOutlet weak var attachemtView: UIView!{
        didSet {
            attachemtView.layer.cornerRadius = 6
            attachemtView.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            attachemtView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var orderiDText: UITextField! {
        didSet {
            orderiDText.delegate = self
        }
    }
    
    
    @IBOutlet weak var orderIdButton: UIButton!{
        didSet {
            orderIdButton.setTitle(lngConst.orderIdques, for: .normal)
        }
    }
    @IBOutlet weak var oderIdView: UIView!{
        didSet {
            oderIdView.layer.cornerRadius = 6
            oderIdView.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            oderIdView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var reasionDes: UITextView!{
        didSet {
            reasionDes.layer.cornerRadius = 6
            reasionDes.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            reasionDes.layer.borderWidth = 1
            reasionDes.placeholder = lngConst.reasonDescription
            reasionDes.font = UIFont.SF_Regular(14)
            reasionDes.delegate = self
            
            
            
        }
    }
    @IBOutlet weak var name: UITextField!{
        didSet {
            name.font = UIFont.SF_Regular(14)
            name.placeholder = lngConst.name
            name.delegate = self
            
        }
    }
    @IBOutlet weak var sendButton: LoadingButton!{
        didSet {
            sendButton.layer.cornerRadius = 8
            //            sendButton.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            sendButton.layer.borderWidth = 1
            sendButton.setupNextButton(title: lngConst.sendMsg,cornerRadius: 8)
            sendButton.titleLabel?.font = UIFont.SF_Regular(14)
            sendButton.addTarget(self, action: #selector(sendMessageToServer(_:)), for: .touchUpInside)
            
        }
    }
    @IBOutlet weak var bgView: UIView!{
        didSet {
            bgView.layer.cornerRadius = 8
            bgView.layer.borderColor = UIColor.init(0xf2f2f2).cgColor
            bgView.layer.borderWidth = 1
        }
    }
    
    
    var viewModel:  ResionAPi?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getReasonList { result in
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    convenience init(){
        self.init(nibName: xibName.contactUSVC, bundle: .altiencoBundle)
        self.viewModel = ReasionViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupLeftnavigation()
        setUpCenterViewNvigation()
    }
    
    
    func showDropDown(view : UIView,
                      stringArry:[String],
                      completion:@escaping(Int,String)->Void) {
        dropDown.anchorView = view
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = stringArry
        dropDown.selectionAction = {   (index: Int,
                                        item: String) in
            completion(index,item)
            
        }
        dropDown.width = view.bounds.width
        dropDown.show()
    }
    
    
    
    func setReasonValue(){
        if let resion = viewModel?.reasonModel.map({$0.reason ?? ""}) {
            showDropDown(view: self.resionBtm,
                         stringArry: resion) { index, value in
                self.resionBtm.setTitleColor(.black, for: .normal)
                self.resionBtm.setTitle(value, for: .normal)
                let des = self.viewModel?.reasonModel[index].description
                self.reasionDes.text = des
                
                if let placeholderLabel = self.reasionDes.viewWithTag(100) as? UILabel {
                    placeholderLabel.isHidden = !self.reasionDes.text.isEmpty
                }
                self.viewModel?.reasonDes = des
                //                self.viewModel?.reasonID = self.viewModel?.reasonModel[index].id ?? 0
            }
        }
    }
    @IBAction func getReasonValues(_ sender : UIButton){
        
        if viewModel?.reasonModel.count ?? 0 > 0 {
            setReasonValue()
        }else {
            self.resionBtm.showLoading()
            self.view.isUserInteractionEnabled = false
            viewModel?.getReasonList(completion: { result  in
                DispatchQueue.main.async {
                    self.resionBtm.hideLoading()
                    self.view.isUserInteractionEnabled = true
                    if result == true {
                        self.setReasonValue()
                    }
                }
                
            })
        }
        
    }
    
    @IBAction func sendMessageToServer(_ sender : UIButton) {
        self.view.endEditing(true)
        switch viewModel?.validateFileds() {
        case .Invalid(let error ):
            Helper.showToast(error)
        default : break
        }
    }
    
    
    @IBAction func infoIcon(_ sender: Any) {
        if viewModel?.infoSelected == true {
            viewModel?.infoSelected = false
            orderiDText.setError()
        }else {
            viewModel?.infoSelected = true
            orderiDText.setError(lngConst.orderidHint, show: true,constent: -11)
        }
    }
}


extension ContactUSVC : UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == name {
            viewModel?.name = textField.text
        }
        if textField == email {
            viewModel?.email = textField.text
        }
        if textField == mobile {
            viewModel?.mobile = textField.text
        }
    }
    
}

extension ContactUSVC : UITextViewDelegate {
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == reasionDes {
            viewModel?.reasonDes = textView.text
        }
    }
}
