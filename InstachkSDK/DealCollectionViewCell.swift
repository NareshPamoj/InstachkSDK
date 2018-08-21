//
//  FreelancerCell.swift
//  CollectionView
//
//  Created by Amit Chatterjee on 13/8/18.
//  Copyright © 2018 Amit Chatterjee. All rights reserved.
//

import UIKit

class DealCollectionViewCell : UICollectionViewCell {

    var lblDealDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lblNameDeal: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageViewDeal: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var viewDeals: UIView = {
        let view = UIView()
        view.contentMode = UIViewContentMode.scaleAspectFit
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }

    
    func addViews(){
        backgroundColor = UIColor.white
        contentView.addSubview(viewDeals)
        viewDeals.addSubview(imageViewDeal)
        viewDeals.addSubview(lblNameDeal)
        viewDeals.addSubview(lblDealDescription)
        
        viewDeals.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewDeals.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        viewDeals.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        viewDeals.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        imageViewDeal.topAnchor.constraint(equalTo: viewDeals.topAnchor, constant: 0).isActive = true
        imageViewDeal.widthAnchor.constraint(equalToConstant: viewDeals.frame.width).isActive = true
        imageViewDeal.heightAnchor.constraint(equalToConstant: 160).isActive = true
        imageViewDeal.rightAnchor.constraint(equalTo: viewDeals.rightAnchor, constant: 0).isActive = true
        imageViewDeal.leftAnchor.constraint(equalTo: viewDeals.leftAnchor, constant: 0).isActive = true
        imageViewDeal.bottomAnchor.constraint(equalTo: lblNameDeal.topAnchor, constant: -10).isActive = true
        

        lblNameDeal.bottomAnchor.constraint(equalTo: lblDealDescription.topAnchor, constant: -10).isActive = true
        lblNameDeal.rightAnchor.constraint(equalTo: viewDeals.rightAnchor, constant: 0).isActive = true
        lblNameDeal.leftAnchor.constraint(equalTo: viewDeals.leftAnchor, constant: 5).isActive = true

        lblDealDescription.rightAnchor.constraint(equalTo: viewDeals.rightAnchor, constant: 5).isActive = true
        lblDealDescription.leftAnchor.constraint(equalTo: viewDeals.leftAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
