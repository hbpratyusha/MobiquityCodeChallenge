//
//  ForecastCell.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
class ForecastCell: UICollectionViewCell {
    static let cellIdentifier            = "ForecastCell"
    @IBOutlet weak var lblTemp      : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    var didTapDelete: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lblTemp?.text = ""
        lblTime?.text = ""
        self.imgWeather.image = nil
    }
    
    func setData(city: ForeCastModel) {
        lblTemp?.text = "\(city.mainData?.temperature ?? 0)"
        lblTime?.text = city.time ?? ""
        self.imgWeather.image = UIImage(named: city.weatherData?.first?.icon ?? "")
    }
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        if let handler = self.didTapDelete {
            handler(sender.tag)
        }
    }
}
extension ForecastCell {
    class func dequeue(from view: UICollectionView, for indexPath: IndexPath) -> ForecastCell {
        if let cell = view.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ForecastCell {
            return cell
        }
        return ForecastCell()
    }
}
