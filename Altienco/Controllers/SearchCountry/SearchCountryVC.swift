//
//  SearchCountryVC.swift
//  Altienco
//
//  Created by Ashish on 28/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit
import SkeletonView
protocol searchDelegate{
    func updateSearchView(isUpdate: Bool, selectedCountry: SearchCountryModel?)
}

class SearchCountryVC: UIViewController,  UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "searchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.sectionFooterHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.estimatedSectionFooterHeight = 1
            tableView.estimatedSectionHeaderHeight = 1
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            tableView.tableFooterView = UIView.init(frame: .zero)
            tableView.tableHeaderView = UIView.init(frame: .zero)
            tableView.isSkeletonable = true
            
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel : SearchCountryViewModel?
    var filteredData: [SearchCountryModel] = []
    var delegate: searchDelegate? = nil
    
    convenience init() {
        self.init(nibName: "SearchCountryVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        viewModel = SearchCountryViewModel()
        self.setupLeftnavigation()
        self.setUpCenterViewNvigation()
        self.initiateModel()
        
        
    }
    
    func initiateModel() {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.lightGray.withAlphaComponent(0.3)), animation: nil, transition: .crossDissolve(0.26))
        
        
        viewModel?.getCountryList { result in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.stopSkeletonAnimation()
                self?.tableView.hideSkeleton()
                self?.filteredData = self?.viewModel?.searchCountry.value ?? []
                self?.tableView.reloadData()
            }
        }
        viewModel?.searchCountry.bind(listener: { (val) in
            self.filteredData = val
            self.tableView.reloadData()
        })
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let model
            = self.viewModel?.searchCountry.value{
            if searchText == ""{
                filteredData = model
            }
            else{
                filteredData = model.filter {
                    $0.countryName?.range(of: searchText, options: .caseInsensitive) != nil
                }}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }}
        tableView.reloadData()
    }
}


extension SearchCountryVC : SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "searchCell"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        cell.labelText?.text = self.filteredData[indexPath.row].countryName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.updateSearchView(isUpdate: true, selectedCountry: self.filteredData[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
}
