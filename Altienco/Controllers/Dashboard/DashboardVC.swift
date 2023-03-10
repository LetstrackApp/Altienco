//
//  DashboardVC.swift
//  Altienco
//
//  Created by Ashish on 05/08/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SideMenu
import SkeletonView
import FSPagerView
class DashboardVC: FloatingPannelHelper {
    
    var adResponse = [AdvertismentResponseObj]()
    var advertismentModel : AdvertismentViewModel?
    var notificationDataViewModel : NewNotificationViewModel?
    var leftNavSlide : SideMenuNavigationController?
    var panGesture = UIPanGestureRecognizer()
    var effectView: UIVisualEffectView!
    var timer : Timer?
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var adCardView: UIView!{
        didSet {
            adCardView.dropShadow()
            adCardView.layer.cornerRadius = 8

        }
    }
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
    @IBOutlet weak var advertismentView: FSPagerView!{
        didSet{
            advertismentView.layer.cornerRadius = 8.0
            advertismentView.clipsToBounds=true
            advertismentView.dataSource = self
            advertismentView.delegate = self
            advertismentView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            advertismentView.automaticSlidingInterval = 2
            advertismentView.isInfinite = true
            advertismentView.decelerationDistance = 2
            
        }
    }
    
    @IBOutlet weak var walletView: UIView!{
        didSet{
            walletView.layer.cornerRadius = 8.0
            walletView.clipsToBounds=true
            walletView.dropShadow(shadowRadius: 2, offsetSize: CGSize(width: 0, height: 0), shadowOpacity: 0.3, shadowColor: .black)
        }
    }
    
    @IBOutlet weak var serviceView: UIView!{
        didSet{
            serviceView.layer.cornerRadius = 8.0
            serviceView.clipsToBounds=true
            serviceView.dropShadow(shadowRadius: 2, offsetSize: CGSize(width: 0, height: 0), shadowOpacity: 0.3, shadowColor: .black)
        }
    }
    @IBOutlet weak var rechargeView: UIView!{
        didSet{
            rechargeView.layer.borderWidth = 0.5
            rechargeView.layer.borderColor = UIColor.lightGray.cgColor
            rechargeView.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var topupView: UIView!{
        didSet{
            topupView.layer.borderWidth = 0.5
            topupView.layer.borderColor = UIColor.lightGray.cgColor
            topupView.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var transferView: UIView!{
        didSet{
            transferView.layer.borderWidth = 0.5
            transferView.layer.borderColor = UIColor.lightGray.cgColor
            transferView.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var cardView: UIView!{
        didSet{
            cardView.layer.borderWidth = 0.5
            cardView.layer.borderColor = UIColor.lightGray.cgColor
            cardView.layer.cornerRadius = 6.0
        }
    }
    
    //// top history View
    
    @IBOutlet weak var statementText: UILabel!{
        didSet{
            statementText.font = UIFont.SF_Medium(12.0)
            statementText.numberOfLines = 2
            statementText.textColor = .black
        }
    }
    @IBOutlet weak var SpentText: UILabel!{
        didSet{
            SpentText.font = UIFont.SF_Medium(12.0)
            SpentText.numberOfLines = 2
            SpentText.textColor = .black
        }
    }
    @IBOutlet weak var voucherText: UILabel!{
        didSet{
            voucherText.font = UIFont.SF_Medium(12.0)
            voucherText.numberOfLines = 2
            voucherText.textColor = .black
        }
    }
    
    /// Service view title
    @IBOutlet weak var rechargeTitle: UILabel!{
        didSet{
            rechargeTitle.font = UIFont.SFPro_Light(12.0)
            rechargeTitle.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var rechargeDetail: UILabel!{
        didSet{
            rechargeDetail.font = UIFont.SF_Medium(14.0)
            rechargeDetail.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var topupTitle: UILabel!{
        didSet{
            topupTitle.font = UIFont.SFPro_Light(12.0)
            topupTitle.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var topupDetail: UILabel!{
        didSet{
            topupDetail.font = UIFont.SF_Medium(14.0)
            topupDetail.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var transferTitle: UILabel!{
        didSet{
            transferTitle.font = UIFont.SFPro_Light(12.0)
            transferTitle.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var transferDetail: UILabel!{
        didSet{
            transferDetail.font = UIFont.SF_Medium(14.0)
            transferDetail.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var cardTitle: UILabel!{
        didSet{
            cardTitle.font = UIFont.SFPro_Light(12.0)
            cardTitle.textColor = appColor.lightGrayText
        }
    }
    @IBOutlet weak var cardDetail: UILabel!{
        didSet{
            cardDetail.font = UIFont.SF_Medium(14.0)
            cardDetail.textColor = appColor.blackText
        }
    }
    @IBOutlet weak var notificationIcon: UIImageView!
    //    @IBOutlet weak var sliderCollection: UICollectionView!
    
    @IBOutlet weak var fspageControl: FSPageControl! {
        didSet {
            fspageControl.hidesForSinglePage = true
            fspageControl.contentHorizontalAlignment = .center
            fspageControl.setFillColor(.gray, for: .normal)
            fspageControl.setFillColor(.white, for: .selected)
            fspageControl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            fspageControl.roundFromBottom(radius: 8)
            fspageControl.currentPage = 1
        }
    }
    @IBOutlet weak var blanceStackView: UIStackView!
    
    
    lazy var addAndShowBalance : AddAndShowBalance? = {
        let control = AddAndShowBalance.loadFromNib(from: .altiencoBundle)
        control.roundFromTop(radius: 8)
        control.configure { [weak self] result in
            self?.showWallet()
        }
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        self.advertismentModel = AdvertismentViewModel()
        self.notificationDataViewModel = NewNotificationViewModel()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.refreshAdData()
        onLanguageChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
        setUpCenterViewNvigation()
        self.updateProfilePic()
        DispatchQueue.main.async {
            self.refreshNotificationData()
        }
        
    }
    
    func onLanguageChange() {
        
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        self.timer?.invalidate()
    }
    
    
    
    func refreshNotificationData() {
        let model = AllNotificationRequest.init(customerID: UserDefaults.getUserData?.customerID ?? 0, langCode: "en")
        
        notificationDataViewModel?.getNewNotification(model: model)
        { (notificationData, status) in
            DispatchQueue.main.async { [weak self] in
//                self?.hideGradientEffect()
                if status == true, let data = notificationData{
                    var model = UserDefaults.getUserData
                    if let isRead = data.first?.anyNewNotification, isRead == true{
                        UserDefaults.setNotificationRead(data: true)
                        self?.notificationIcon.image = UIImage(named: "ic_notificationRead")
                    }
                    else{
                        self?.notificationIcon.image = UIImage(named: "ic_notification")
                        UserDefaults.setNotificationRead(data: false)
                    }
                    if let walletAmount = data.first?.amount{
                        model?.walletAmount = walletAmount
                        if model != nil {
                            UserDefaults.setUserData(data: model!)
                        }
                        self?.addAndShowBalance?.setUpBalanaceView(walletAmount: walletAmount)
                        
                    }
                }
            }
            
        }
        
    }
    
    func refreshAdData() {
        let model = AdvertismentRequestObj.init(customerID: UserDefaults.getUserData?.customerID ?? 0, screenID: "1", langCode: "en")
        
        advertismentModel?.getAdData(model: model, complition: { (adData, status) in
            DispatchQueue.main.async { [weak self] in
//                self?.hideGradientEffect()
                if status == true{
                    self?.updateSlider()
                    self?.adCardView.isHidden = false
                    self?.adResponse = adData ?? []
                    
                }
                else{
                    self?.adCardView.isHidden = true
                }
            }})
    }
    func updateSlider(){
        DispatchQueue.main.async {
            self.cardView.isHidden = false
            self.advertismentView.reloadData()
                        self.fspageControl.numberOfPages = self.adResponse.count
        }
    }
 
    
    func setupValue(){
        if let firstname = UserDefaults.getUserData?.firstName{
            self.userName.text = "Hi \(firstname)"
        }
        addAndShowBalance?.setUpBalanaceView(walletAmount: UserDefaults.getUserData?.walletAmount ?? 0)
        
        
    }
    
    
    
    
    func initializeView()
    {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "ic_menu_black_24dp"), for: .normal)
        // button.setTitle("Menu", for: .normal)
        button.addTarget(self, action: #selector(self.action), for: .touchUpInside)
        button.sizeToFit()
        button.tintColor = .black
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: button)
        
        DispatchQueue.main.async { [weak self] in
            
            if let view = self?.addAndShowBalance {
                self?.blanceStackView.insertArrangedSubview(view, at: 0)
                self?.addAndShowBalance?.widthAnchor.constraint(equalToConstant: self?.blanceStackView.bounds.width ?? 0).isActive = true
                self?.addAndShowBalance?.setUpBalanaceView(walletAmount: UserDefaults.getUserData?.walletAmount ?? 0)
                
            }
            self?.InitializeLeftView()
        }
    }
    
    func InitializeLeftView()
    {
        leftNavSlide = SideMenuNavigationController(rootViewController: LeftScreenVC())
        SideMenuManager.default.leftMenuNavigationController = leftNavSlide
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.menuWidth = UIScreen.main.bounds.width - (UIScreen.main.bounds.width/7)
        settings.statusBarEndAlpha = 0
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
    
    
}


extension DashboardVC: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
        // Do any additional setup after loading the view, typically from a nib.
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        effectView = UIVisualEffectView(effect: blurEffect)
        effectView.alpha = 0.7
        effectView.frame = view.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(effectView)
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
        self.effectView.removeFromSuperview()
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}






//MARK: - Routing
extension DashboardVC {
    @objc func action(){
        self.present(leftNavSlide!, animated: true, completion: nil)
    }
    
    @IBAction func transactionHistory(_ sender: Any) {
        let viewController: TransactionHistoryVC = TransactionHistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func myOrder(_ sender: Any) {
        let viewController: HistoryVC = HistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func voucherHistory(_ sender: Any) {
        let viewController: VoucherHistoryVC  = VoucherHistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func rechargeButton(_ sender: Any) {
        let viewController: OperatorListVC = OperatorListVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func iRechargeButton(_ sender: Any) {
        let viewController: TopupVC = TopupVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notification(_ sender: Any) {
        setupAllNoti()
    }
    @IBAction func transferCard(_ sender: Any) {
        
        let viewController: AllCallingCardVC = AllCallingCardVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func createCard(_ sender: Any) {
        let viewController: GiftCardVC = GiftCardVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showWallet()
    {
        
        
        //            let obj = AlertViewVC.init(type: .transactionSucessfull(amount: "11000"))
        //            obj.modalPresentationStyle = .overFullScreen
        //            self.present(obj, animated: false, completion: nil)
        //            obj.onCompletion = {
        //                //self?.navigationController?.popToRootViewController(animated: true)
        //            }
        
        
        
        let viewController: WalletPaymentVC = WalletPaymentVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension DashboardVC :FSPagerViewDataSource,FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.adResponse.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let data = self.adResponse[index]
        cell.imageView?.sd_setImage(with: URL(string: data.thumbnail ?? ""), placeholderImage: nil, options: [], context: nil)
        self.fspageControl.currentPage = index+1
        return cell
    }
    
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.fspageControl.currentPage = targetIndex
    }
    
    
}
