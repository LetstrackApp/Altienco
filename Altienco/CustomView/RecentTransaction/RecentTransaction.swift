//
//  RecentTransaction.swift
//  Altienco
//
//  Created by mac on 20/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class RecentTransaction : UIControl,ViewLoadable {
    static var nibName: String = xibName.recentTransaction
    var recentTransactionAPI : RecentTransactionAPI!
    typealias complitionCloser = (Bool?) -> ()
    private var complition : complitionCloser?
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "HistoryCell", bundle: nil),
                               forCellReuseIdentifier: "HistoryCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func configure(with recentTransactionAPI: RecentTransactionAPI = RecentTransactionViewModel(),
                   complition : @escaping complitionCloser) ->Void {
        self.complition = complition
        self.recentTransactionAPI = recentTransactionAPI
        self.dataBinding()
    }
    
    
    func dataBinding(){
        recentTransactionAPI.historyList.bind { result in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        recentTransactionAPI.callHistoryData()
        
    }
    
    
}

extension RecentTransaction : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentTransactionAPI.historyList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        return cell
    }
    
    
}
