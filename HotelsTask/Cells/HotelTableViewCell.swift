//
//  HotelTableViewCell.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 2.4.23..
//

import UIKit

class HotelTableViewCell: UITableViewCell {
  
  @IBOutlet weak private var thumbnailImageView: LazyImageView!
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var addressLabel: UILabel!
  @IBOutlet weak private var priceLabel: UILabel!
  @IBOutlet weak private var starView: StarView!
  
  func setCell(_ model: HotelCellModel) {
    starView.isHidden = false
    resetCell()
    nameLabel.text = model.name
    addressLabel.text = model.address
    if let price = model.price {
      let formatedPrice = String.localizedStringWithFormat(NSLocalizedString("%d_aed", comment: ""), price)
      priceLabel.text = formatedPrice
    }
    if let url = model.thumbnailUrl {
      self.thumbnailImageView.loadImage(fromURL: url, placeHolderImage: "hotel_placeholder")
    }
    
    starView.setRating(model.starRating)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    resetCell()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func resetCell() {
    nameLabel.text = ""
    priceLabel.text = ""
    addressLabel.text = ""
    thumbnailImageView.image = UIImage(named: "hotel_placeholder")
  }
  
}
