//
//  WeekForeCastCell.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 02/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import UIKit
class WeekForeCastCell: UITableViewCell {
    static let cellIdentifier            = "WeekForeCastCell"
    @IBOutlet weak var lblDate      : UILabel!
    @IBOutlet weak var hourGrid : UICollectionView!
    private var arrData: [ForeCastModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDate?.text = ""
        self.backgroundColor = UIColor.clear
        self.arrData = []
        self.hourGrid.reloadData()
    }
    
    func setData(city: ForeCastDay) {
        self.lblDate?.text = city.title ?? ""
        self.arrData = city.forecastArr ?? []
        self.hourGrid.reloadData()
        self.backgroundColor = UIColor.clear
    }
}
extension WeekForeCastCell {
    class func dequeue(from view: UITableView, for indexPath: IndexPath) -> WeekForeCastCell {
        if let cell = view.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeekForeCastCell {
            return cell
        }
        return WeekForeCastCell()
    }
}
extension WeekForeCastCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ForecastCell.dequeue(from: collectionView, for: indexPath)
        if let foreCast = self.arrData[safe: indexPath.row] {
            cell.setData(city: foreCast)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if IS_iPAD {
//            return CGSize(width: 200, height: 200)
//        } else {
//            return CGSize(width: 100, height: 100)
//        }
 //   }
}
