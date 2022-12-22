//
//  AllDenomination.swift
//  Altienco
//
//  Created by Deepak on 13/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AllDenomination: UIViewController{
    var SelectedIndex = -1
    var countryModel : SearchCountryModel? = nil
    var language = "EN"
    var planType = 2
    var operatorID = 0
    var backgroundCode : UIColor?
    var giftCardLogo = ""
    var viewModel : FixedCardViewModel?
    var filteredData: [FixedGiftResponseObj] = []
    
    
    let screen = UIScreen.main.bounds
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
            self.profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            self.profileImage.layer.borderColor = appColor.lightGrayBack.cgColor
            self.profileImage.layer.borderWidth = 1.0
            self.profileImage.contentMode = .scaleToFill // OR .scaleAspectFill
            self.profileImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var logoContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.logoContainer.layer.shadowPath = UIBezierPath(rect: self.logoContainer.bounds).cgPath
                self.logoContainer.layer.shadowRadius = 5
                self.logoContainer.layer.shadowOffset = .zero
                self.logoContainer.layer.shadowOpacity = 1
                self.logoContainer.layer.cornerRadius = 8.0
                self.logoContainer.clipsToBounds=true
            }
            self.logoContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 5
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
            self.viewContainer.clipsToBounds=true
        }
    }
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = 5.0
            logoImage.layer.borderWidth = 1.0
            logoImage.layer.borderColor = appColor.lightGrayBack.cgColor
            logoImage.clipsToBounds=true
        }
    }
    @IBOutlet weak var denominationCollection: UICollectionView!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var viewMoreContainer: UIView!
    @IBOutlet weak var moreTextContainer: UIView!
    @IBOutlet weak var moreText: UILabel!
    
    @IBOutlet weak var descActionText: UILabel!
    @IBOutlet weak var hideDesc: UIButton!
    @IBOutlet weak var generateGiftCard: UIButton!{
        didSet{
            self.generateGiftCard.setupNextButton(title: "GENERATE GIFT CARD")
        }
    }
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showNotify()
        self.updateProfilePic()
        self.setupValue()
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
    }
    func updateProfilePic(){
        if (UserDefaults.getUserData?.profileImage) != nil
        {
            
            if let aString = UserDefaults.getUserData?.profileImage
            {
                if UserDefaults.getAvtarImage == "1"{
                    self.profileImage.image = UIImage(named: aString)
                }else{
                    let newString = aString.replacingOccurrences(of: baseURL.imageURL, with: baseURL.imageBaseURl, options: .literal, range: nil)
                    
                    self.profileImage.sd_setImage(with: URL(string: newString), placeholderImage: UIImage(named: "defaultUser"))
                }
            }
        }
        
    }
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
    }
    func showNotify(){
        if UserDefaults.isNotificationRead == "1"{
            self.notificationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notificationIcon.image = UIImage(named: "ic_notification")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FixedCardViewModel()
        self.denominationCollection.register(UINib(nibName: "CollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionHeight.constant = 0.0
        self.initiateModel()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        if giftCardLogo != "" {
            self.logoImage.sd_setImage(with: URL(string: giftCardLogo), placeholderImage: UIImage(named: "ic_operatorLogo"))
        }
        else{
            self.logoImage.image = UIImage(named: "ic_operatorLogo")
        }
        //            self.logoContainer.backgroundColor = backgroundCode
    }
    
    func initiateModel() {
        var countryCode = UserDefaults.getCountryCode
        if let details = self.countryModel?.countryISOCode {
            countryCode = details
        }
        viewModel?.getFixedGiftCards(countryCode: countryCode ?? "", language: "EN", planType: self.planType, operatorID: self.operatorID)
        viewModel?.searchFixedGiftCard.bind(listener: { (val) in
            self.filteredData = val
            let screenWidth = self.screen.size.width
            let height = (screenWidth/4)
            if val.isEmpty == false{
                if (val.count % 2) == 0{
                    self.collectionHeight.constant = CGFloat(Int(height) * ( (val.count / 2)))
                }else{
                    self.collectionHeight.constant = CGFloat(Int(height) *  ((val.count / 2) + 1))
                }
                
                self.SelectedIndex = 0
                self.showDescription()
            }
            self.denominationCollection.reloadData()
        })
    }
    
    func showDescription(){
        var info = ""
        if let details = filteredData.first?.objDescription{
            self.detailLabel.text = details
        }
        if let usageInfo = filteredData.first?.usageInfo{
            for i in 0..<usageInfo.count{
                info = info + "\n\(usageInfo[i])"
            }
            self.moreText.text = info
            self.viewMoreContainer.isHidden = false
        }
        else{
            self.viewMoreContainer.isHidden = true
        }
        
    }
    var showMoreClicked = false
    @IBAction func showMoreDesc(_ sender: Any) {
        if self.showMoreClicked == false{  self.showMoreClicked = true
            self.moreTextContainer.isHidden = false
            //            self.descActionText.text = "Hide"
        }else{
            self.showMoreClicked = false
            self.moreTextContainer.isHidden = true
            //            self.descActionText.text = "View more"
        }
        
    }
    
    @IBAction func reviewGiftCard(_ sender: Any) {
        if self.SelectedIndex != -1{
            guard let selectedAmount = self.viewModel?.searchFixedGiftCard.value[self.SelectedIndex].retailAmount else {return}
            guard let walletBal = UserDefaults.getUserData?.walletAmount else {return}
            if Int(selectedAmount) > Int(walletBal ) {
                let alertController = UIAlertController(title: "Insufficent Balance", message: "Please add wallet balance", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "ADD", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let viewController: WalletPaymentVC = WalletPaymentVC()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                DispatchQueue.main.async {
                    if let selectedPlan = self.viewModel?.searchFixedGiftCard.value[self.SelectedIndex]{
                        self.callReviewPopup(PlanType: 2, selectedPlan: selectedPlan)
                    }
                }
            }
        }
    }
    
    func successVoucher(denominationVal: Double, confirmObj: ConfirmIntrResponseObj, giftCardName: String){
        let viewController: SuccessGiftCardVC = SuccessGiftCardVC()
        viewController.denominationAmount = denominationVal
        viewController.countryName = self.countryModel?.countryName ?? ""
        viewController.countryCode = self.countryModel?.countryISOCode ?? ""
        viewController.GiftCardName = giftCardName
        viewController.externalId = confirmObj.externalID ?? ""
        viewController.processStatusID = confirmObj.processStatusID ?? 0
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func setupWalletBal(walletBal: Double){
        var model = UserDefaults.getUserData
        model?.walletAmount = walletBal
        if model != nil{
            UserDefaults.setUserData(data: model!)
        }
        
    }
    func callReviewPopup(PlanType: Int, selectedPlan : FixedGiftResponseObj){
        ReviewGiftCardVC.initialization().showAlert(usingModel: selectedPlan,
                                                    planType: planType) { result, isSuscess in
            if isSuscess == true {
                DispatchQueue.main.async {
                    if isSuscess, let data = result{
                        if let selectedPlan = self.viewModel?.searchFixedGiftCard.value[self.SelectedIndex]{
                            self.setupWalletBal(walletBal: data.walletAmount ?? 0.0)
                            self.successVoucher(denominationVal: selectedPlan.retailAmount ?? 0.0, confirmObj: data, giftCardName: selectedPlan.operatorName ?? "")
                            
                        }
                    }
                }
            }
        }
        //vc.delegate = self
        //        vc.planType = planType
        //        vc.selectedFixedPlan = selectedPlan
        //        vc.modalPresentationStyle = .overFullScreen
        //        vc.view.backgroundColor = .clear
        //        self.present(vc, animated: false, completion: nil)
    }
    
}
//extension AllDenomination: BackTOGiftCardDelegate {
//    func BackToPrevious(dismiss: Bool, result: ConfirmIntrResponseObj?) {
//        if dismiss, let data = result{
//            if let selectedPlan = self.viewModel?.searchFixedGiftCard.value[self.SelectedIndex]{
//                self.setupWalletBal(walletBal: data.walletAmount ?? 0.0)
//                self.successVoucher(denominationVal: selectedPlan.retailAmount ?? 0.0, confirmObj: data, giftCardName: selectedPlan.operatorName ?? "")
//
//            }
//        }}}


extension AllDenomination: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == self.SelectedIndex{
            cell.viewContainer.backgroundColor = appColor.blackText
            cell.plansValue.textColor = .white
        }
        else{
            cell.viewContainer.backgroundColor = .white
            cell.plansValue.textColor = appColor.blackText
        }
        //        cell.isHighlighted = true
        if let planVlaue = self.viewModel?.searchFixedGiftCard.value[indexPath.row].retailAmount, let currency = self.viewModel?.searchFixedGiftCard.value[indexPath.row].currencySymbol {
            cell.plansValue.text = currency + " " + String(format: "%.2f", planVlaue)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.row < self.viewModel?.operatorPlanList.value.count ?? 0{
        //            DispatchQueue.main.async {
        self.SelectedIndex = indexPath.row
        self.denominationCollection.reloadData()
        //            }
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  15
        let collectionViewSize = collectionView.frame.size.width - padding
        let screenWidth = self.screen.size.width
        let height = (screenWidth/5)
        return CGSize(width: collectionViewSize/2, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.viewContainer.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.viewContainer.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    
    
}
