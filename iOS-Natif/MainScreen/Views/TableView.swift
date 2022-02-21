//
//  TableView.swift
//  iOS-Natif
//
//  Created by Earth on 20.02.2022.
//

import UIKit

class TableView: UITableView {

    func getСonfiguredCell(for indexPath: IndexPath) -> TableCell {
        dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
    }
    
    func setConfiguration() {
        let nib = UINib(nibName: "TableCell", bundle: nil)
        register(nib, forCellReuseIdentifier: "TableCell")
        separatorStyle = .none
    }
}
