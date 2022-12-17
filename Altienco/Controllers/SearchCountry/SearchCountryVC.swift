//
//  SearchCountryVC.swift
//  Altienco
//
//  Created by Ashish on 28/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

protocol searchDelegate{
    func updateSearchView(isUpdate: Bool, selectedCountry: SearchCountryModel?)
}

class SearchCountryVC: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
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
        self.initiateModel()
        self.tableView.register(UINib(nibName: "searchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        
    }
    
    func initiateModel() {
        viewModel?.getCountryList()
        viewModel?.searchCountry.bind(listener: { (val) in
            self.filteredData = val
            self.tableView.reloadData()
        })
        
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
