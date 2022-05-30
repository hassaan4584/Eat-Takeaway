//
//  RestaurantListCell.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import UIKit
import SDWebImage

class RestaurantListCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantRatingsLabel: UILabel!
    @IBOutlet weak var restaurantCuisineFilter: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!

    static let cellIdentifier: String = "RestaurantListCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupViews()
    }

    private func setupViews() {
        let highlightedView = UIView()
        highlightedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightedView
    }

    /// Update cell data
    /// - Parameter restaurant: Restaurant object against which the cell is to be populated
    func setCellData(_ restaurant: Restaurant) {
        self.restaurantNameLabel.text = restaurant.name ?? "-"
        if let ratings = restaurant.ratingStars {
            self.restaurantRatingsLabel.text = "\(ratings)"
        } else {
            self.restaurantRatingsLabel.text = "-"
        }
        if let cuinesNames = (restaurant.cuisineTypes?.compactMap { $0.name }) {
            self.restaurantCuisineFilter.text = cuinesNames.joined(separator: ", ")
        } else {
            self.restaurantCuisineFilter.text = "-"
        }
        if let imageUrlStr = restaurant.logoUrl, let imageUrl = URL(string: imageUrlStr) {
            self.restaurantImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "imagePlaceholder"))
        }
    }
}
