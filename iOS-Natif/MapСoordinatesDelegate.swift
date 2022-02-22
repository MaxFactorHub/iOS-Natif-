//
//  Зкщещсщд.swift
//  iOS-Natif
//
//  Created by Earth on 21.02.2022.
//

import Foundation

protocol MapСoordinatesDelegate: AnyObject {
    func getCoordinates(latitude: Double, longitude: Double)
    func updateCoordinates()
}
