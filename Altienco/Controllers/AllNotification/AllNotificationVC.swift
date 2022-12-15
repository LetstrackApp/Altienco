//
//  AllNotificationVC.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AllNotificationVC: UIViewController {

    var viewModel: AllNotificationViewModel?
    var AllNotification : [AllNotificationResponce] = []
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var notificationTable: UITableView!
    @IBOutlet weak var userName: UILabel!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AllNotificationViewModel()
        self.notificationTable.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        self.getAllNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupValue()
        self.updateProfilePic()
        self.showNotify()
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
    
    @IBAction func redirectProfile(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let viewController: AllNotificationVC = AllNotificationVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getAllNotification() {
        let model = AllNotificationRequest.init(customerID: UserDefaults.getUserData?.customerID, langCode: "en")
        viewModel?.getNotification(model: model, complition: { (notification, status) in
            DispatchQueue.main.async { [weak self] in
            if status == true, let data = notification{
                UserDefaults.setNotificationRead(data: false)
                self?.AllNotification = data
                self?.showNotify()
                self?.notificationTable.reloadData()
            }
            }})
    }
    
}



extension AllNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.AllNotification.count == 0 {
                self.notificationTable.setEmptyMessage("No records found!")
            } else {
                self.notificationTable.restore()
            }
        return self.AllNotification.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
         let model = self.AllNotification[indexPath.row]
        
            cell.title.text = model.title
        cell.orderNumber.text = "Order Number: \(model.notificationID ?? 0)"
            cell.descText.text = model.details
            
            if let time = model.notificationDate{
                cell.dateTime.text = time.convertToDisplayFormat()
            }
        return cell
        }
}
