//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by sheshnath kumar on 10/6/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func config(weatherInfo:WeatherInfo)  {
        self.fromLabel.text = "From: \(weatherInfo.from ?? "")"
        self.toLabel.text = "To: \(weatherInfo.to ?? "")"
        self.temperatureLabel.text = "Temperature: \(weatherInfo.temperature ?? "" )"
    }
}
