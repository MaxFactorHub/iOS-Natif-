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
    private var detectedPositions: [(ty: String, ry: String)] = []
    private var selectedPositions: (ty: String, ry: String)?
    weak var delegate: MapŠ”oordinatesDelegate?

    // MARK: - loadCoordinates
    @objc private func loadCoordinates() {
        if let searchText = searchBar.text {
            if !searchText.isEmpty {
                OpenWeatherApi.getCoordinates(by: selectedPositions?.ty ?? "") { welcomeElement in
                    self.delegate?.getCoordinates(latitude: welcomeElement.lat, longitude: welcomeElement.lon)
                    self.delegate?.updateCoordinates()
                }
            }
        }
        addAlert(message: "Data has been sent to the Home Screen")
    }

    // MARK: - addAlert
    private func addAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultTable.dataSource = self
        resultTable.delegate = self
        let image = UIImage(named: "ic_search")
        let selector = #selector(self.loadCoordinates)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: selector)
        self.navigationItem.titleView = searchBar

        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem?.tintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.tintColor = .black
        searchBar.searchTextField.placeholder = "Š”ŃŃŠ¾ŠŗŠ° ŠæŠ¾ŠøŃŠŗŠ°"
        searchBar.searchTextField.leftView = nil
        let message = "ŠŃŠæŠ¾Š»ŃŠ·ŃŠ¹ŃŠµ ŠæŠ°Š½ŠµŠ»Ń ŠæŠ¾ŠøŃŠŗŠ°.\nŠŠ¾ŃŠ»Šµ Š²Š²ŠµŠ“ŠµŠ½ŠøŃ Š½ŠµŠ¾Š±ŃŠ¾Š“ŠøŠ¼Š¾Š¹ Š»Š¾ŠŗŠ°ŃŠøŠø Š½Š°Š¶Š¼ŠøŃŠµ rightBarButtonItem Š“Š»Ń Š¾ŃŠæŃŠ°Š²ŠŗŠø Š“Š°Š½Š½ŃŃ Š½Š° ŠŠ»Š°Š²Š½ŃŠ¹ ŃŠŗŃŠ°Š½. ŠŠøŃŠøŠ»Š»ŠøŃŠ° Š² ŠæŠ°Š½ŠµŠ»Šø ŠæŠ¾ŠøŃŠŗŠ° ŠŗŠ¾ŃŃŠµŠŗŃŠ½Š¾ Š½Šµ ŃŠ°Š±Š¾ŃŠ°ŠµŃ."
        addAlert(message: message)
    }
}

// MARK: - UITableViewDataSource
extension FindViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detectedPositions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        if !detectedPositions.isEmpty {
            let ty = detectedPositions[indexPath.row].ty
            let ry = detectedPositions[indexPath.row].ry
            content.text = "\(ty), \(ry)"
        }
        content.textProperties.alignment = .center
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ty = detectedPositions[indexPath.row].ty
        let ry = detectedPositions[indexPath.row].ry
        searchBar.text = "\(ty), \(ry)"
        selectedPositions = (ty, ry)
        resultTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            selectedPositions = (searchText, "")
            RapidApi.requestWithDelayControl(with: searchText, completion: { welcome in
                self.detectedPositions.removeAll()
                if let data = welcome.data {
                    for item in data {
                        self.detectedPositions.append((item.name, item.country))
                    }
                }
                DispatchQueue.main.async { self.resultTable.reloadData() }
            })
            resultTable.reloadData()
        }
    }
}
