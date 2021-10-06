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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func config(weatherInfo:WeatherInfo)  {
        self.fromLabel.text = weatherInfo.from
        self.toLabel.text = weatherInfo.to
    }
}
