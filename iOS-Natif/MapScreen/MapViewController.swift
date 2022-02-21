//
//  MapViewController.swift
//  iOS-Natif
//
//  Created by Earth on 17.02.2022.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Variables
    private var touchCoordinates: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)?
    @IBOutlet private weak var mapView: MKMapView!
    private var coordinatePoint: MKPointAnnotation?
    weak var delegate: MapСoordinatesDelegate?
        
    // MARK: - mapViewTapped
    @objc func mapViewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.view is MKMapView && recognizer.state == .began {
                let touchPoint = recognizer.location(in: mapView)
            let coordinates = getMapCoordinates(from: touchPoint)
                updateAnnotationCoordinates(latitude: coordinates.latitude, longitude: coordinates.longitude)
                delegate?.getCoordinates(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
    }
    
    // MARK: - showUserCoordinates
    private func showUserCoordinates(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        setMapAnnotation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    // MARK: - setMapAnnotation
    private func setMapAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        coordinatePoint = annotation
        mapView.addAnnotation(annotation)
    }
     
    // MARK: - updateAnnotationCoordinates
    private func updateAnnotationCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        setMapAnnotation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    // MARK: - getMapCoordinates
    private func getMapCoordinates(from touchPoint: CGPoint) -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print ("Tap coordinates: \(location.latitude), \(location.longitude)")
        return (latitude: location.latitude, longitude: location.longitude)
    }
        
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped(_:)))
        gestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        LocationManager.set(delegate: self)
        LocationManager.locationManagerSettings()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.backBarButtonItem?.tintColor = .white
    }
        
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateCoordinates()
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) { fatalError() }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            showUserCoordinates(location)
        }
    }
}



