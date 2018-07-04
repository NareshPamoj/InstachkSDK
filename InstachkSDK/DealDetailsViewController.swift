
//
//  DealDetailsViewController.swift
//  InstachkOffers
//
//  Created by Naresh on 22/05/18.
//

import UIKit
import Kingfisher

class DealDetailsViewController: UIViewController {
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var lblDealTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dealDetailsView: UIView!
    @IBOutlet weak var imageViewDeal: UIImageView!
    @IBOutlet weak var imageViewD: UIImageView!
    @IBOutlet weak var lblDealName: UILabel!
    @IBOutlet weak var lblDealDescription: UILabel!
    @IBOutlet weak var lblTimeValidity: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTermsAndConditions: UILabel!
    @IBOutlet weak var activateBtn: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageViewActivateDeal: UIImageView!

    @IBOutlet weak var viewActivateDeal: UIView! {
        didSet {
            viewActivateDeal.isHidden = true
        }
    }
    
    var dealsDict = [String: Any]()
    var dealTermsAndConditions : String?
    var dealDescription:String?
    var dealName : String?
    var imageDealURL : String?
    var imageActivateDealURL : String?
    var imageVD:String?
    var startTime :String?
    var endTime : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        view.backgroundColor = UIColor.white
    }
    
    func setData() {
        imageViewD.setRounded()
        imageViewActivateDeal.setRounded()
        viewActivateDeal.viewShadow()
        viewNavigation.viewShadow()
        
        lblDealDescription.text = dealDescription
        lblTermsAndConditions.text = dealTermsAndConditions
        lblDealName.text = dealName
        lblDealTitle.text = dealName
        
        if let url = imageDealURL {
            imageViewDeal.kf.setImage(with: URL(string: url))
            imageViewActivateDeal.kf.setImage(with: URL(string: url))
            imageViewD.kf.setImage(with: URL(string: url))
        }

        if let startTime = startTime , let endTime = endTime {
          lblTime.text = "\(UTCToLocal(date: startTime))" + " - " + "\(UTCToLocal(date: endTime))"
        }
    }
    
    @IBAction func activateNoBtnClicked(_ sender: UIButton) {
        viewActivateDeal.isHidden = true
    }
    
    @IBAction func activateYesBtnClicked(_ sender: UIButton) {
        activateBtn.setTitle("DEAL IS ACTIVATED", for: .normal)
        if (imageActivateDealURL != nil) {
            if let url = URL(string: imageActivateDealURL ?? "") {
                // open the url in browser
                UIApplication.shared.open(url)
            }
        }
        viewActivateDeal.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func activateBtnClicked(_ sender: UIButton) {
        viewActivateDeal.isHidden = false
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

/*
 
 ["start_time": 04:15:00,
 "shop_address": CA Site No:1, Behind Hotel Leela Palace, HAL 3rd Stage, 560008, HAL 2nd Stage, Kodihalli, Bengaluru, Karnataka 560018, India,
 "shop_image_url": <null>,
 "description": Description Test Campaign 21 Dec ,
 "expiry_time": 2018-12-26T06:15:00.000Z,
 "action_url": http://35.185.19.20:3000/customer/coupons/51fdbccedc0a45e98ffcfd4f22161b27,
 "end_timestamp": 2018-12-26T06:15:00.000+00:00,
 "mall_name": Kemp Fort Mall,
 "id": 3404,
 "end_time": 06:15:00,
 "title": Test Campaign 21 Dec ,
 "image_url": https://storage.googleapis.com/instachk-staging/uploads/image/file/2415/Coffee.jpg,
 "shop_name": Naresh Shop,
 "start_timestamp": 2018-12-26T04:15:00.000+00:00,
 "terms_and_conditions": 1. Instachk reserves the right to change these Terms & Conditions.<br/>2. This app is for the sole purpose of viewing deals offered by merchants and purchasing same.<br/>3. Instachk shall not be liable for any damages or failed delivery of the products or services resulting from the use of this app.<br/>4. Products and services are available only in Singapore.<br/>5. Limited to 1 redemption per customer.<br/>6. Not valid with other promotions or discounts.<br/>7. Merchants who push the deals reserve the right to cancel, reject or terminate any deals.<br/>8. By choosing to activate the deals, you agree that Instachk may use your details for marketing purposes.<br/>]
 
 */
