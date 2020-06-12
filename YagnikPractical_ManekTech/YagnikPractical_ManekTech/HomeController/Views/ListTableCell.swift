//
//  ListTableCell.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import SDWebImage
import FloatRatingView

class ListTableCell: UITableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var floatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bgView.setShdowSpecificCorner(shadowColor: UIColor.black.withAlphaComponent(0.3), borderColor: .black, radius: 4, opacity: 4, cornerRadius: [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner], offset: CGSize(width: 0, height: 3))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Custom Methods
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureCell(_ data: Resturant) {
        self.titleLabel.text = data.title ?? ""
        floatingView.rating = Double(data.rating ?? 0) 
        if let data = data.img?.first {
            if let url = Constants.getValidImageURL(with: data.image ?? "") {
                self.mainImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
            }
        }else {
            self.mainImgView.image = UIImage(named: "img")
        }
    }
}
