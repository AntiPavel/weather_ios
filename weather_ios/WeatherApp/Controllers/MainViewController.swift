//
//  MainViewController.swift
//  WeatherApp
//
//  Created by paul on 14/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var network: NetworkService? = appDelegate?.network
    lazy var storage: StorageService? = appDelegate?.storage
    lazy var location: LocationManager? = appDelegate?.location

    @IBOutlet weak var bottomTemp: UILabel?
    @IBOutlet weak var cityTextfield: UITextField?
    @IBOutlet weak var searchButton: UIButton?
    
    @IBAction func textfieldEditEnd(_ sender: Any) {
        print("textfieldEditEnd")
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchCity()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveCity()
    }
    
    @IBAction func updateAction(_ sender: Any) {
        update() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    var searchedWeather: WeatherModel? {
        didSet {
            cityTextfield?.placeholder = searchedWeather?.name
        }
    }
    
    var localWeather: WeatherModel? {
        didSet {
            bottomTemp?.text = localWeather?.description
        }
    }
    
    private func update() {
        location?.startUpdateLocation()
        guard let city = searchedWeather?.name else { return }
        search(city: city)
    }
    
    private func setup() {
        cityTextfield?.delegate = self
        coordinateUpdateListener()
        location?.startUpdateLocation()
        setupHideKeyboardOnTap()
        searchButton?.isEnabled = false
    }
    
    private func searchCity() {
        guard let city = cityTextfield?.text, !city.isEmpty else { return }
        search(city: city)
    }
    
    private func search(city: String) {
        network?.getWeatherAt(city: city) { [weak self] response, _ in
            guard let weather = response else {
                self?.show(error: "City not found!")
                return
            }
            self?.searchedWeather = weather
        }
    }
    
    private func saveCity() {
        guard let id = searchedWeather?.id else { return }
        network?.fetchCityForStorage(id: id) { [weak self] isSuccess in
            guard isSuccess else { return }
            self?.storage?.save()
        }
    }
    
    private func show(error text: String) {
        let alert = UIAlertController(title: nil,
                                      message: text,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: LocalWeatherSubscriber {
    
    @objc func updateWeather(notification: Notification) {
        fetchWeather(notification)
    }
}

extension MainViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//         print("TextField did begin editing method called")
//     }
//     func textFieldDidEndEditing(_ textField: UITextField) {
//         print("TextField did end editing method called\(textField.text!)")
//     }
//     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//         print("TextField should begin editing method called")
//         return true
//     }
     func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchButton?.isEnabled = false
        return true
     }
//     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//         print("TextField should end editing method called")
//         return true
//     }
     func textField(_ textField: UITextField,
                    shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {
        
        var text = textField.text ?? ""
        let startIndex = text.index(text.startIndex, offsetBy: range.location)
        let endIndex = text.index(text.startIndex, offsetBy: range.location + range.length)
        text = text.replacingCharacters(in: startIndex..<endIndex, with: string)
        searchButton?.isEnabled = !text.isEmpty
        
        return true
     }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder()
        searchCity()
        return true
     }
}
