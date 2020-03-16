//
//  CityTableViewController.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var network: NetworkService? = appDelegate?.network
    lazy var storage: StorageService? = appDelegate?.storage
    lazy var location: LocationManager? = appDelegate?.location

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    var cities: [CityModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        updateStorageData()
        cities = storage?.fetchCities() ?? []
        refreshControl?.endRefreshing()
    }
    
    private func updateStorageData() {
        for city in cities {
            network?.fetchCityForStorage(id: city.id.intValue) { [weak self] isSuccess in
                guard isSuccess else { return }
                self?.storage?.save()
            }
        }
    }

    @IBAction func clearAction(_ sender: Any) {
        storage?.cleanCities()
        cities = storage?.fetchCities() ?? []
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CityViewCell.self),
                                                       for: indexPath) as? CityViewCell else { return UITableViewCell() }
        cell.title?.text = cities[indexPath.row].name
        cell.temp?.text = cities[indexPath.row].temp.stringValue + "°C"
        cell.condition?.text = cities[indexPath.row].condition
//        let item = ChatGroupItem(chat: chats[indexPath.item], onDelete: nil)
//        cell.update(with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        storage?.deleteCity(id: cities[indexPath.row].id.intValue)
        cities = storage?.fetchCities() ?? []
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cities"
    }
}
