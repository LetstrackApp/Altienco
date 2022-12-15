//
//  SelectCountryNumberViewController.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit

class SelectCountryNumberViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var numberViewContainer: UIView!
    @IBOutlet weak var nextButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.assignbackground()
        viewContainer.layer.shadowPath = UIBezierPath(rect: viewContainer.bounds).cgPath
        viewContainer.layer.shadowRadius = 5
        viewContainer.layer.shadowOffset = .zero
        viewContainer.layer.shadowOpacity = 1
        viewContainer.layer.cornerRadius = 13
        viewContainer.clipsToBounds=true
        numberViewContainer.layer.cornerRadius = 5
        numberViewContainer.clipsToBounds=true
        nextButton.layer.cornerRadius = 5
        nextButton.clipsToBounds=true
        // Do any additional setup after loading the view.
    }
    

    func assignbackground(){
        let background = UIImage(named: "download.jpeg")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

}


extension UIView {

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 13
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
