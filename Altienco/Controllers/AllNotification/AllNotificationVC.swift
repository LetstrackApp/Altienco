//
//  AllNotificationVC.swift
//  Altienco
//
//  Created by Deepak on 30/11/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class AllNotificationVC: UIViewController {
    
    @IBOutlet weak var allNotification: PaddingLabel! {
        didSet {
            allNotification.topInset = 10
            allNotification.bottomInset = 10
            
        }
    }
    var viewModel: AllNotificationViewModel?
    var AllNotification : [AllNotificationResponce] = []
    @IBOutlet weak var notificationTable: UITableView! {
        didSet {
            self.notificationTable.register(UINib(nibName: "NotificationCell", bundle: nil),
                                            forCellReuseIdentifier: "NotificationCell")

        }
    }
    
    convenience init() {
        self.init(nibName: "AllNotificationVC", bundle: nil)
        self.viewModel = AllNotificationViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllNotification()
        onLanguageChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setUpCenterViewNvigation()
        self.setupLeftnavigation()
    }
    
    
    func onLanguageChange(){
        
        self.allNotification.changeColorAndFont(mainString: lngConst.allNotification.capitalized,
                                                    stringToColor: lngConst.notification.capitalized,
                                                    color: UIColor.init(0xb24a96),
                                                    font: UIFont.SF_Medium(18))
        
        
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
        cell.orderNumber.text = "\(lngConst.orderNo): \(model.notificationID ?? 0)"
        cell.descText.text = model.details
        
        if let time = model.notificationDate{
            cell.dateTime.text = time.convertToDisplayFormat()
        }
        return cell
    }
}
