//
//  AdDialogViewController.swift
//  offers
//
//  Created by Naresh on 18/05/18.
//  Copyright © 2018 Instachk. All rights reserved.
//

import UIKit
import Kingfisher

protocol AdDialogDelegate {
    func onActivateCouponConfirmed()
    func onAdDialogDismissed()
}

public class AdDialogViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var adImage: UIImageView!
    
    public var imageUrl: String = ""
    var delegate: AdDialogDelegate!

    override public func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        viewBackground.addGestureRecognizer(tap)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.superview?.backgroundColor = UIColor.clear
        self.view.superview?.isOpaque = false
        self.modalPresentationStyle = .overCurrentContext
        self.adImage.kf.setImage(with: URL(string: imageUrl))
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
        self.delegate?.onAdDialogDismissed()
    }

    @IBAction func dismissClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        self.delegate?.onAdDialogDismissed()
    }
    
    @IBAction func onConfirmClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        self.delegate?.onActivateCouponConfirmed()
    }
}
