//
//  FindViewController.swift
//  iOS-Natif
//
//  Created by Earth on 17.02.2022.
//

import UIKit

class FindViewController: UIViewController  {
    
    // MARK: - Variables
    @IBOutlet private weak var resultTable: UITableView!
    private let searchBar = UISearchBar()
    private let values = ["London", "Londar", "Lontar"]
    private var sortedValues = [String]()
    weak var delegate: MapСoordinatesDelegate?
           
    // MARK: - sort
    private func sort(searchText: String) {
        sortedValues.removeAll()
        for item in values {
            if item.lowercased().contains(searchText.lowercased()) {
                sortedValues.append(item)
            }
        }
    }
    
    // MARK: - loadCoordinates
    @objc private func loadCoordinates() {
        if let searchText = searchBar.text {
            if !searchText.isEmpty {
                OpenWeatherApi.getCoordinates(by: searchText) { welcomeElement in
                    self.delegate?.getCoordinates(latitude: welcomeElement.lat, longitude: welcomeElement.lon)
                    self.delegate?.updateCoordinates()
                    
                }
            }
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultTable.dataSource = self
        resultTable.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_my_location"), style: .done, target: self, action: #selector(self.loadCoordinates))
        self.navigationItem.titleView = searchBar
        
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem?.tintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.leftView = nil
    }
}

// MARK: - UITableViewDataSource
extension FindViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        if !sortedValues.isEmpty { content.text = sortedValues[indexPath.row] }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = sortedValues[indexPath.row]
        sort(searchText: sortedValues[indexPath.row])
        resultTable.reloadData()
    }
}
 
// MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sort(searchText: searchText)
        resultTable.reloadData()
    }
}
