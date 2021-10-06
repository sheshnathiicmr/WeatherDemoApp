//
//  ViewController.swift
//  Weather
//
//  Created by sheshnath kumar on 10/5/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    //MARK:- Properties
    var viewModel:HomeViewModel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- ViewLifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Info"
        self.tableView.isHidden = true
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.viewModel = HomeViewModel(delegate: self)
    }
}

//MARK:- UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as? WeatherTableViewCell
        cell.config(weatherInfo: self.viewModel.object(at: indexPath)!)
        return cell
    }
}

//MARK:- HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    
    func stateChange(newState:HomeScreenState) {
        print("new state: \(newState)")
        switch newState {
        case .weatherDataAvailable(_):
            self.tableView.isHidden = false
            self.tableView.reloadData()
        default:
            self.infoLabel.text = newState.getDisplayTest
        }
    }
    
}
