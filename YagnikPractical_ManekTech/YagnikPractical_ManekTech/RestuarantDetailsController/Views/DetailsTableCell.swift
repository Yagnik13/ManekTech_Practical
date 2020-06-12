//
//  DetailsTableCell.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import FloatRatingView

class DetailsTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var phoneLable: UILabel!
    @IBOutlet weak var reviewLable: UILabel!
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var floatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
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
        titleLable.text = data.title ?? ""
        phoneLable.text = "\(data.phone_no ?? 0)"
        descLable.text = data.description ?? ""
        addressLable.text = data.address ?? ""
        reviewLable.text = "(\(0) Reviews)"
        floatingView.rating = Double(data.rating ?? 0) 
    }
}
