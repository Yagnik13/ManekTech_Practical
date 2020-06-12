//
//  ImageSliderCollectionViewCell.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import SDWebImage

class ImageSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Custom Methods
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureDataForCell(_ data : String) {
        if let url = Constants.getValidImageURL(with: data) {
            self.sliderImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
        }else {
            self.sliderImageView.image = UIImage(named: "img")
        }
    }
    
}
