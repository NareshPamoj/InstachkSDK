//
//  MessageListener.swift
//  AdViewApp
//
//  Created by Naresh on 6/6/18.
//  Copyright © 2018 Instachk. All rights reserved.
//

import UIKit

@objc protocol MessageListener {
   @objc func instachkOnMessageReceived(message : String)
   @objc optional func onCouponActivated(advertisement_id: Int)
   @objc optional func onCouponActivated(deal_id: Int)
}
