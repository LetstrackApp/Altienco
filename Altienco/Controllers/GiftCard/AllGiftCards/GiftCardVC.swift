//
//  GiftCardVC.swift
//  Altienco
//
//  Created by Deepak on 10/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import FlagKit

class GiftCardVC: UIViewController, searchDelegate {
    func updateSearchView(isUpdate: Bool, selectedCountry: SearchCountryModel?) {
        if isUpdate == true && selectedCountry != nil{
            countryModel = selectedCountry
            if let countryCode = selectedCountry?.countryISOCode2{
                self.selectedSegament = 1
                self.setupFlag(countryCode: countryCode, isUpdate: isUpdate)
                self.initiateModel(countryCode: countryCode)
            }
        }
    }
    
    var countryModel : SearchCountryModel? = nil
    var viewModel : AllGiftCardViewModel?
    var filteredData: [GiftCardResponce] = []
    var lastFilterData: [GiftCardResponce] = []
//    var backgroundCode = [UIColor]()
    var segementData = ["FEATURED", "A-Z", "OCCATIONS", "LUXURY"]
    var selectedSegament = 1
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
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var segmentCollection: UICollectionView!
    @IBOutlet weak var giftCardCollection: UICollectionView!
    
    @IBOutlet weak var flagLogo: UIImageView!{
        didSet{
            self.flagLogo.layer.cornerRadius = self.flagLogo.layer.frame.size.height/2
            self.flagLogo.clipsToBounds = true
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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var collectionAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AllGiftCardViewModel()
        self.segmentCollection.register(UINib(nibName: "SegmentCell", bundle:nil), forCellWithReuseIdentifier: "SegmentCell")
        self.giftCardCollection.register(UINib(nibName: "GiftCardCell", bundle:nil), forCellWithReuseIdentifier: "GiftCardCell")
        if UserDefaults.getCountryCode == "IND"{
            self.initiateModel(countryCode: "IND")
            self.setupFlag(countryCode: "IN", isUpdate: false)
        }
        else{
            self.initiateModel(countryCode: "GBR")
            self.setupFlag(countryCode: "GB", isUpdate: false)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupValue()
        self.updateProfilePic()
        self.showNotify()
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
    }
    func showNotify(){
        if UserDefaults.isNotificationRead == "1"{
            self.notificationIcon.image = UIImage(named: "ic_notificationRead")
        }
        else{
            self.notificationIcon.image = UIImage(named: "ic_notification")
        }
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
    
    
    func setupFlag(countryCode: String, isUpdate: Bool){
        if isUpdate == true{
            let flag = Flag(countryCode: countryCode)
            let originalImage = flag?.originalImage
            flagLogo.image = originalImage
        }
        else{
            let flag = Flag(countryCode: countryCode)
            let originalImage = flag?.originalImage
            flagLogo.image = originalImage
        }
    }
    func initiateModel(countryCode: String) {
        viewModel?.getGiftCards(countryCode: countryCode, language: "EN", pageNum: 1, pageSize: 100)
        viewModel?.searchGiftCard.bind(listener: { (val) in
            self.filteredData.removeAll()
            self.filteredData = val
            self.lastFilterData = self.filteredData
            self.segmentCollection.reloadData()
            self.giftCardCollection.reloadData()
        })
    }
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func searchCountry(_ sender: Any) {
        let viewController: SearchCountryVC = SearchCountryVC()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func createSegmentData() {
        var filterGiftCard = [GiftCardResponce]()
        if self.selectedSegament == 0{
            filterGiftCard = filteredData.filter { ($0.isFeatured == true)}
        }
        else if self.self.selectedSegament == 2{
            filterGiftCard = filteredData.filter { ($0.isOccasions == true)}
        }
        else if self.selectedSegament == 3{
            filterGiftCard = filteredData.filter { ($0.isLuxury == true)}
        }
        else{
            filterGiftCard = filteredData
        }
        self.lastFilterData = filterGiftCard
        self.giftCardCollection.reloadData()
    }
    
}


extension GiftCardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == segmentCollection{
            return self.segementData.count
        }
        else{
            self.lastFilterData.isEmpty == true ?
                (self.collectionAlert.isHidden = false) : (self.collectionAlert.isHidden = true)
            return self.lastFilterData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == segmentCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
            
            if indexPath.row == self.selectedSegament{
                cell.selectedView.isHidden = false
                cell.filterName.textColor = appColor.blueColor
            }
            else{
                cell.selectedView.isHidden = true
                cell.filterName.textColor = appColor.lightGrayText
            }
            cell.filterName.text = self.segementData[indexPath.row]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCell", for: indexPath) as! GiftCardCell
            if let image = self.lastFilterData[indexPath.row].operatorImageURL {
                var imageUrl = image
                imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
                cell.operatorLogo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "ic_operatorLogo"))
            }
            else{
                cell.operatorLogo.image = UIImage(named: "ic_operatorLogo")
            }
//            cell.cardColor.backgroundColor = self.backgroundCode[indexPath.row]
            cell.operatorName.text = self.lastFilterData[indexPath.row].operatorName
            cell.showDenomination.tag = indexPath.row
            cell.showDenomination.addTarget(self, action: #selector(callOperatorPlans(sender:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == segmentCollection{
            self.selectedSegament = indexPath.row
            self.segmentCollection.reloadData()
            DispatchQueue.main.async {
                self.createSegmentData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == giftCardCollection{
            let padding: CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2 + 15)
        }else {
            let collectionFlowLayout = UICollectionViewFlowLayout()
            collectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
            return collectionFlowLayout.itemSize
        }
    }
    
    
    
    @objc func callOperatorPlans(sender: UIButton){
        if sender.tag >= 0{
            if self.lastFilterData[sender.tag].planTypeID == 1 || self.lastFilterData[sender.tag].planTypeID == 3{
                let viewController: AllDenomination = AllDenomination()
                if let image = self.lastFilterData[sender.tag].operatorImageURL {
                    viewController.giftCardLogo = image
                }
//                viewController.backgroundCode = self.backgroundCode[sender.tag]
                viewController.countryModel = self.countryModel
                viewController.operatorID = self.lastFilterData[sender.tag].operatorID ?? 0
                viewController.planType = self.lastFilterData[sender.tag].planTypeID ?? 0
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                let viewController: RangeCardVC = RangeCardVC()
                //                viewController.oper
                if let image = self.lastFilterData[sender.tag].operatorImageURL {
                    viewController.giftCardLogo = image
                }
//                viewController.backgroundCode = self.backgroundCode[sender.tag]
                viewController.countryModel = self.countryModel
                viewController.language = "EN"
                viewController.planType = self.lastFilterData[sender.tag].planTypeID ?? 0
                viewController.operatorID = self.lastFilterData[sender.tag].operatorID ?? 0
                viewController.currentValue = 0.0
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }}
}



//extension UIColor {
//
//    static func random() -> UIColor {
//        return UIColor.rgb(CGFloat.random(in: 0..<256), green: CGFloat.random(in: 0..<256), blue: CGFloat.random(in: 0..<256))
//    }
//
//    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
//        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
//    }
//
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//
//    convenience init(rgb: Int) {
//        self.init(
//            red: (rgb >> 16) & 0xFF,
//            green: (rgb >> 8) & 0xFF,
//            blue: rgb & 0xFF
//        )
//    }
//
//    static func getColor() -> UIColor {
//        let chooseFrom = [0x064545,0x708545,0x45580] //Add your colors here
//        return UIColor.init(rgb: chooseFrom[Int.random(in: 0..<chooseFrom.count)])
//    }
//
//}
