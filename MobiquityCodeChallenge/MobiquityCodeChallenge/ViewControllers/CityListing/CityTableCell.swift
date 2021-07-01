//
//  CityTableCell.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 01/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
class CityTableCell: UITableViewCell {
    static let cellIdentifier            = "CityTableCell"
    @IBOutlet weak var lblCityName      : UILabel!
    @IBOutlet weak var lblCountryName : UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    var didTapDelete: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lblCityName?.text = ""
        lblCountryName?.text = ""
        self.btnDelete.isHidden = true
        self.backgroundColor = UIColor.clear
    }
    
    func setData(city: CityModel) {
        lblCityName?.text = city.cityName ?? ""
        lblCountryName?.text = city.country ?? ""
        self.btnDelete.isHidden = city.isDefault
        self.backgroundColor = UIColor.clear
    }
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        if let handler = self.didTapDelete {
            handler(sender.tag)
        }
    }
}
extension CityTableCell {
    class func dequeue(from view: UITableView, for indexPath: IndexPath) -> CityTableCell {
        if let cell = view.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableCell {
            return cell
        }
        return CityTableCell()
    }
}
