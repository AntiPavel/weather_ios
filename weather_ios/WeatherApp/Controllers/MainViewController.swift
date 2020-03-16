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
    lazy var imageProvider: ImageProvider? = appDelegate?.imageProvider

    @IBOutlet weak var cityTitle: UILabel?
    @IBOutlet weak var weatherDescription: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var tempLabel: UILabel?
    @IBOutlet weak var backgroundImage: UIImageView?
    @IBOutlet weak var localLabel: UILabel?
    @IBOutlet weak var localCityTitle: UILabel?
    @IBOutlet weak var localDescription: UILabel?
    @IBOutlet weak var localIcon: UIImageView?
    @IBOutlet weak var bottomTemp: UILabel?
    @IBOutlet weak var cityTextfield: UITextField?
    @IBOutlet weak var searchButton: UIButton?
    @IBOutlet weak var addButton: UIButton?
    @IBOutlet weak var localImage: UIImageView?

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    var searchedWeather: WeatherModel? {
        didSet {
            updateMainView()
        }
    }
    
    var localWeather: WeatherModel? {
        didSet {
            updateBottomView()
        }
    }
    
    private func updateMainView() {
        guard let weather = searchedWeather else { return }
        cityTitle?.text = weather.name
        tempLabel?.text = String(weather.temp) + Constants.celsius
        weatherDescription?.text = weather.description
        ///use  condition and descritpion as tags to request image from Flickr storage
        setBackgoundImage(tag: weather.condition,
                          cluster: weather.description.split{!$0.isLetter}.joined(separator: "/"))
//        weatherIcon?.image = UIImage(named: "")
    }
    
    private func updateBottomView() {
        guard let weather = localWeather else { return }
        bottomTemp?.text = String(weather.temp) + Constants.celsius
        localLabel?.text = "Your local weather:"
        localCityTitle?.text = weather.name
        localDescription?.text = weather.description
        ///use  condition and descritpion as tags to request image from Flickr storage
        setBottomBackgoundImage(tag: weather.condition,
                                cluster: weather.description.split{!$0.isLetter}.joined(separator: "/"))
//        localIcon?.image = UIImage(named: "")
    }
    
    private func update() {
        location?.startUpdateLocation()
        guard let city = searchedWeather?.name else { return }
        search(city: city)
    }
    
    private func setup() {
        cityTextfield?.delegate = self
        coordinateUpdateListener()
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
    
    // MARK: Image Provider
    private func setBackgoundImage(tag: String, cluster: String) {
        imageProvider?.getImage(tag: tag, cluster: cluster) { [weak self] image in
            guard image != nil else { return }
            self?.backgroundImage?.image = image
            self?.backgroundImage?.contentMode = .scaleToFill
        }
    }
    
    private func setBottomBackgoundImage(tag: String, cluster: String) {
        imageProvider?.getImage(tag: tag, cluster: cluster) { [weak self] image in
            guard image != nil else { return }
            self?.localImage?.image = image
            self?.localImage?.contentMode = .scaleToFill
        }
    }
}

extension MainViewController: LocalWeatherSubscriber {
    
    @objc func updateWeather(notification: Notification) {
        fetchWeather(notification)
    }
}

extension MainViewController: UITextFieldDelegate {

     func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchButton?.isEnabled = false
        return true
     }

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
