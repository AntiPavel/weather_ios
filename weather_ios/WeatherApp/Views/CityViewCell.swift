//
//  CityViewCell.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

class CityViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var temp: UILabel?
    @IBOutlet weak var condition: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
