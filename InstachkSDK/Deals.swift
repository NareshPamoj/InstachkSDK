//
//  Deals.swift
//  InstachkOffers
//
//  Created by Naresh on 21/05/18.
//  Copyright © 2018 Instachk. All rights reserved.
//

import UIKit
import ARSLineProgress

public class Deals: NSObject {
    
    var deals = [[String: Any]]()
    var service : InstachkService?
    var partnerKey: String
    var container: UIView! = nil
    var collectionView:UICollectionView!
    var dealsDictionary = [String:Any]()
    let MyCollectionViewCellId: String = "dealscell"

    public init(container: UIView,partnerKey: String) {
        self.container = container
        self.partnerKey = partnerKey
        super.init()
        bind(partnerKey: self.partnerKey)
        collectioViewSetUp()
        getStoredDeals()
    }
    
    public func bind(partnerKey: String) {
        self.service = InstachkService(partnerKey: partnerKey)
        service!.initialize()
        service!.setDelegate(delegate: self)
    }
    
    private func collectioViewSetUp() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:140 , height: 255)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame:CGRect(x: 0, y: 100, width: container.frame.size.width, height: container.frame.size.height), collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.register(DealCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCellId)
        collectionView.backgroundColor = UIColor.white
        container.addSubview(collectionView)
    }
    
    /**
     gets deals from user defaults and converts them back to dict
     */
    func getStoredDeals() {        
        do {
            let dataold = UserDefaults.standard.data(forKey: "deals")
            if(dataold == nil) {
                return
            }
            guard let dealsOld = try JSONSerialization.jsonObject(with: dataold!, options: [])
                as? [[String: Any]]
                else {
                       print("Could not get JSON from responseData as dictionary")
                       return
                     }
            deals = dealsOld
        } catch {
            print("Error fetching local ads: \(error.localizedDescription)")
        }
    }
}

extension Deals : MessageListener {
    func instachkOnMessageReceived(message: String) {
        do {
            let data = message.data(using: String.Encoding.utf8)!
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            
            if (json["type"] != nil && json["deals"] != nil) {
                // render new deals
                if let deals = json["deals"] as? [[String: Any]] {
                    self.deals.removeAll()
                    self.deals = deals
                    print(deals)
                    
                    if deals.count > 0 {
                       collectionView.dataSource = self
                       collectionView.delegate = self
                    } else {
                        let nodealsLbl = UILabel()
                        nodealsLbl.frame.origin = CGPoint(x: 0, y: self.container.frame.height / 2)
                        nodealsLbl.frame.size = CGSize(width: container.frame.width, height: 41)
                        nodealsLbl.text  = "No deals found"
                        nodealsLbl.font = UIFont.boldSystemFont(ofSize: 34)
                        nodealsLbl.textAlignment = .center
                        nodealsLbl.textColor = UIColor.darkGray
                        nodealsLbl.sizeToFit()
                        container.addSubview(nodealsLbl)
                        nodealsLbl.center = container.center
                    }
                    
                    // store the deals in user defaults
                    let deals: NSData = jsonToNSData(json: self.deals)!
                    let userDefaults = UserDefaults.standard
                    _ = userDefaults.set(deals, forKey: "deals")
                }
            }
        }
        catch {
            print("Error parsing response 2 \(error.localizedDescription)")
            return
        }
    }
}

extension Deals : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! DealCollectionViewCell
        
          dealsDictionary = deals[indexPath.row]
          cell.lblNameDeal.text = dealsDictionary["title"] as? String
          cell.lblDealDescription.text = dealsDictionary["description"] as? String
          if let image_url = dealsDictionary["thumb_url"] as? String {
            cell.imageViewDeal.kf.setImage(with: URL(string:image_url))
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)! as! DealCollectionViewCell
        let vc = DealDetailsViewController(nibName: "DealDetailsViewController", bundle: Bundle.init(for: DealDetailsViewController.self))
                
        dealsDictionary = deals[indexPath.row]
        vc.dealName = cell.lblNameDeal.text
        vc.dealDescription = cell.lblDealDescription.text
        vc.imageDealURL = dealsDictionary["thumb_url"] as? String
        vc.startTime = dealsDictionary["start_time"] as? String
        vc.endTime = dealsDictionary["end_time"] as? String
        vc.imageVD = dealsDictionary["thumb_url"] as? String
        vc.dealTermsAndConditions = (dealsDictionary["terms_and_conditions"] as! String).replacingOccurrences(of: "<br/>", with:"\n" )
        vc.imageActivateDealURL = dealsDictionary["action_url"] as? String
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.container.parentViewController?.showDetailViewController(vc, sender: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height:255)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 120, right: 8)
    }
}
