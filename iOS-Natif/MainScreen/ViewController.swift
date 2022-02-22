//
//  ViewController.swift
//  iOS-Natif
//
//  Created by Earth on 16.02.2022.
//

import UIKit
import CoreLocation
import Swinject

class ViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet private weak var collectionView: CollectionView!
    @IBOutlet private weak var tableView: TableView!
    @IBOutlet private weak var labelView: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    private var mainView: MainView!
    private var userLocation: (latitude: Double, longitude: Double)?
    
    // MARK: - pushSearchController
    @objc private func pushSearchController() {
        let memberDetailsViewController = storyboard!.instantiateViewController(withIdentifier: "FindViewController") as! FindViewController
        memberDetailsViewController.delegate = self
        self.navigationController?.pushViewController(memberDetailsViewController, animated: true)
    }
    
    // MARK: - pushMapController
    @objc private func pushMapController() {
        let memberDetailsViewController = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        memberDetailsViewController.delegate = self
        self.navigationController?.pushViewController(memberDetailsViewController, animated: true)
        
    }
    
    // MARK: - refreshUIData
    private func refreshUIData() {
        DispatchQueue.main.async {
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(OpenWeather.getDataTimeZone(), for: .normal)
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).sizeToFit()
            self.labelView.text = OpenWeather.getCurrentDate()
            let data = OpenWeather.getCurrentData()
            self.temp.text = String(data.temp)
            self.humidity.text = String(data.humidity)
            self.windSpeed.text = String(data.windSpeed)
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = self.view as? MainView
        collectionView.registerNib()
        tableView.setConfiguration()
        
        let button = mainView.navigationItemsInstallation1()
        button.addTarget(self, action: #selector(pushMapController), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        let rightBarButtonItem = mainView.navigationItemsInstallation2()
        rightBarButtonItem.action = #selector(self.pushSearchController)
        rightBarButtonItem.target = self
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.backButtonDisplayMode = .minimal
        
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        LocationManager.set(delegate: self)
    }
    
// MARK: - preferredStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: - Map_Сoordinates_Delegate
extension ViewController: MapСoordinatesDelegate {
    func updateCoordinates() {
        if let location = userLocation {
            OpenWeatherApi.getWeather(latitude: Double(location.latitude), longitude: Double(location.longitude), completion: { welcome in OpenWeather.set(weatherData: welcome)
                self.refreshUIData()
            })
        }
    }
    
    func getCoordinates(latitude: Double, longitude: Double) {
        userLocation = (latitude: latitude, longitude: longitude)
        let location = "Delegated coordinates: \(latitude), \(longitude)"
        print(location)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        OpenWeather.getHourlyCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.getСonfiguredCell(for: indexPath)
        cell.middleView.image = UIImage(named: "ic_white_day_cloudy")
        cell.topLabel.text = OpenWeather.getHourlyDate(from: indexPath.row)
        cell.bottomLabel.text = String(OpenWeather.getHourly()[indexPath.row].temp)
        return cell
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.getСonfiguredCell(for: indexPath)
        cell.setConfiguration()
        cell.leftLabel.text = OpenWeather.getDeilyDate(from: indexPath.row)
        let temp = OpenWeather.getDeily()[indexPath.row].temp
        cell.centerLabel.text = "\(temp.max)/\(temp.min)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        OpenWeather.getDeilyCount()
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! TableCell
        cell.setSelectConfiguration()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! TableCell
        cell.setDeselectConfiguration()
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        ///fatalError()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        LocationManager.locationManagerSettings()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocationManager.stopUpdatingLocation()
        if let coordinate = LocationManager.getCoordinate() {
            OpenWeatherApi.getWeather(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude), completion: { welcome in OpenWeather.set(weatherData: welcome)
                self.refreshUIData()
            })
        }
    }
}


