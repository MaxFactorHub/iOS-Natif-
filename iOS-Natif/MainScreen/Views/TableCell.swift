//
//  TableCell.swift
//  iOS-Natif
//
//  Created by Earth on 16.02.2022.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    func setSelectConfiguration() {
        centerLabel.textColor = UIColor(named: "#5a9ff0")
        rightImage.tintColor = UIColor(named: "#5a9ff0")
        leftLabel.textColor = UIColor(named: "#5a9ff0")
        contentView.backgroundColor = .white
        contentView.layer.shadowOpacity = 5
        contentView.layer.shadowOffset = CGSize(width: 10,
                                                height: 10)
        contentView.layer.shadowColor = CGColor(red: 34, green: 80, blue: 100, alpha: 0)
    }
    
    func setDeselectConfiguration() {
        centerLabel.textColor = .black
        rightImage.tintColor = .black
        leftLabel.textColor = .black
    }
    
    func setConfiguration() {
        rightImage.image = UIImage(named: "ic_white_day_cloudy")
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
