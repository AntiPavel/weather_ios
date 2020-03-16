//
//  ImageProvider.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

protocol ImageProvider {
    
    func getImage(tag: String, cluster: String, result: @escaping (UIImage?) -> Void)
}
