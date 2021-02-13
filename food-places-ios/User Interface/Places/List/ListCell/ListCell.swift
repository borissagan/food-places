//
//  ListCell.swift
//  food-places-ios
//
//  Created by Boris Sagan on 13.02.2021.
//

import UIKit

class ListCell: UICollectionViewCell {
  static let identifier = String(describing: ListCell.self)
  static let nib = UINib(nibName: String(describing: ListCell.self), bundle: nil)
  
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure(with place: Place) {
    nameLabel.text = place.info.name
  }
  
}
