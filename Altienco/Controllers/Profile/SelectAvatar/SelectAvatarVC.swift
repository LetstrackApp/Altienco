//
//  SelectAvatarVC.swift
//  Altienco
//
//  Created by Ashish on 14/09/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import UIKit

class SelectAvatarVC: UIViewController {

    var imageName = ""
    var SelectedIndex = -1
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewContainer.layer.shadowPath = UIBezierPath(rect: self.viewContainer.bounds).cgPath
                self.viewContainer.layer.shadowRadius = 6
                self.viewContainer.layer.shadowOffset = .zero
                self.viewContainer.layer.shadowOpacity = 1
                self.viewContainer.layer.cornerRadius = 8.0
                self.viewContainer.clipsToBounds=true
            }
        }
    }
    @IBOutlet weak var done: UIButton!{
        didSet{
            self.done.setupNextButton(title: "Done")
        }
    }
    @IBOutlet weak var avatarCollection: UICollectionView!
    
    typealias alertCompletionBlock = ((Bool?, String?) -> Void)?
    
    private var block : alertCompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarCollection.register(UINib(nibName: "AvatarCell", bundle:nil), forCellWithReuseIdentifier: "AvatarCell")
        // Do any additional setup after loading the view.
    }
    
    static func initialization() -> SelectAvatarVC{
        let alertController = SelectAvatarVC(nibName: "SelectAvatarVC", bundle: nil)
        return alertController
    }
    
    private func show(){
        DispatchQueue.main.async {
        if  let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            topViewController.addChild(self)
            topViewController.view.addSubview(self.view)
            self.viewWillAppear(true)
            self.didMove(toParent: topViewController)
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.alpha = 0.0
            self.view.frame = topViewController.view.bounds
            self.viewContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                self.view.alpha = 1.0
                self.viewContainer.alpha = 1.0
                self.viewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
                }, completion: nil)
                self.avatarCollection.reloadData()
            } }
        }
    
    @IBAction func homeBuuton(_ sender: Any) {
        self.hide()
        self.block!!(false, nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if self.imageName != ""{
            self.hide()
            self.block!!(true, self.imageName)
        }
        else{
            self.alert(message: "Please select profile pic to set first!", title: "Alert")
        }
    }
    
    
    
    func setupView(){
    }

    
    /// Hide Alert Controller
    @objc private func hide(){
        self.view.endEditing(true)
        self.viewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.viewContainer.alpha = 0.0
            self.viewContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.viewContainer.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            
        }) {  (completed) -> Void in
            
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    public func showPopup(usingModel currency : String, completion : alertCompletionBlock){
        show()
        block = completion
    }
    
    deinit {
        print("deinit");
    }
}





extension SelectAvatarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatarPics.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        if indexPath.row == self.SelectedIndex{
            cell.contentView.backgroundColor = appColor.lightGrayBack
        }
        else{
            cell.contentView.backgroundColor = .white
        }
        cell.avatarImage.image = AvatarPics.element(at: indexPath.row)?.setImage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < AvatarPics.allCases.count{
            DispatchQueue.main.async {
                self.SelectedIndex = indexPath.row
                self.imageName = AvatarPics.element(at: indexPath.row)?.name ?? "defaultUser"
                self.avatarCollection.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat =  15
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/4, height: collectionViewSize/4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? AvatarCell {
                cell.avatarImage.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            if let cell = collectionView.cellForItem(at: indexPath) as? AvatarCell {
                cell.avatarImage.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    

}
