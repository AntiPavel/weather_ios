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
    @IBOutlet weak var icon: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
