//
//  MainView.swift
//  iOS-Natif
//
//  Created by Earth on 20.02.2022.
//

import UIKit

class MainView: UIView {

    func navigationItemsInstallation1() -> UIButton {
        let leftButton = UIButton(type: .system)
        leftButton.tintColor = .white
        leftButton.setImage(UIImage(named: "ic_place"), for: .normal)
        leftButton.setTitle("", for: .normal)
        leftButton.titleLabel?.font = UIFont(name: "", size: 15)
        leftButton.sizeToFit()
        leftButton.titleLabel?.textAlignment = .left
        leftButton.contentHorizontalAlignment = .left
        return leftButton
    }

    func navigationItemsInstallation2() -> UIBarButtonItem {
        let image = UIImage(named: "ic_my_location")
        let rightButton = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        rightButton.tintColor = .white
        return rightButton
    }
}
