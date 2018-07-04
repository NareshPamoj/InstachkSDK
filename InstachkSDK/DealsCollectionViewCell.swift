//
//  DealsCollectionViewCell.swift
//  InstachkOffers
//
//  Created by Naresh on 21/05/18.
//  Copyright © 2018 Instachk. All rights reserved.
//

import UIKit

class DealsCollectionViewCell: UICollectionViewCell {

    @IBOutlet  var viewDeals: UIView!
    @IBOutlet  var imageViewDeal: UIImageView!
    @IBOutlet  var lblNameDeal: UILabel!
    @IBOutlet  var lblDealDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewDeals = UIView(frame: CGRect(x: 0, y: 0, width: 162, height: 255))
        viewDeals.contentMode = UIViewContentMode.scaleAspectFit
        viewDeals.layer.shadowColor = UIColor.lightGray.cgColor
        viewDeals.layer.shadowOpacity = 0.5
        viewDeals.layer.shadowOffset = CGSize.zero
        viewDeals.layer.shadowRadius = 3
        viewDeals.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(viewDeals)
        
        imageViewDeal = UIImageView(frame: CGRect(x: 0, y: 0, width: 162, height:186))
        imageViewDeal.contentMode = UIViewContentMode.scaleAspectFit
        viewDeals.addSubview(imageViewDeal)
                
        lblNameDeal = UILabel(frame:CGRect(x: 10, y: 184, width: 135, height: 34))
        lblNameDeal.numberOfLines = 2
        lblNameDeal.textColor = UIColor.black
        lblNameDeal.font = UIFont.boldSystemFont(ofSize: 14)
        viewDeals.addSubview(lblNameDeal)

        lblDealDescription = UILabel(frame:CGRect(x: 10, y: 215, width: 135, height: 20))
        lblNameDeal.numberOfLines = 2
        lblDealDescription.textColor = UIColor.darkGray
        lblDealDescription.font = UIFont.systemFont(ofSize: 12)
        viewDeals.addSubview(lblDealDescription)
    }
    
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
