//
//  Extention.swift
//  LMDispatcher
//
//  Created by APPLE on 14/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import SystemConfiguration
import UIKit


extension UIView {
    
    func addShadow(offSet:CGSize = CGSize(width: 0.0, height: 0.0)) {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = offSet
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
    }
    
    
  
    
    func deleteShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
    }
    
    func shakeView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    // OUTPUT 1
    func dropShadow(color: UIColor, scale: Bool = true) {
        DispatchQueue.main.async {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 1
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        DispatchQueue.main.async {
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offSet
            self.layer.shadowRadius = radius
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
        
    }
}

extension UIView {
    func dropShadow( shadowRadius: CGFloat = 2.0, offsetSize: CGSize = CGSize(width: 2, height: 5), shadowOpacity: Float = 0.5, shadowColor: UIColor = UIColor.lightGray ) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offsetSize
        layer.shadowRadius = shadowRadius
    }
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension UIButton {
    func imageToRight() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}



class customDropDown : UIButton {
    var selectedTitle = UILabel()
    
    func addDropdown(offset: CGFloat,title:String,image : UIImage = UIImage(named: "dropdown")!){
        selectedTitle.text = title
        selectedTitle.tintColor = .blue
        let imageview =  UIImageView(image: image)
        imageview.contentMode = .scaleAspectFit
        self.addSubview(selectedTitle)
        self.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        imageview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: image.size.width > 70 ? 70 : image.size.width).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: self.bounds.height - 10).isActive = true
        selectedTitle.translatesAutoresizingMaskIntoConstraints = false
        selectedTitle.numberOfLines = 1
        selectedTitle.minimumScaleFactor = 0.5
        selectedTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        selectedTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset).isActive = true
        selectedTitle.trailingAnchor.constraint(equalTo: imageview.leadingAnchor, constant: -10).isActive = true
    }
    
    
    
}


extension UIButton {
    func addImagelabel(offset: CGFloat,title:String,image : UIImage){
        let label = UILabel()
        let myStringArr = title.components(separatedBy: ":")
        if myStringArr.count > 1
        {
            let myAttribute = [ NSAttributedString.Key.font: UIFont.SF_Bold(15.0)]
            let lastAttribute = [ NSAttributedString.Key.font: UIFont.SF_Regular(15.0)]
            let myString = NSMutableAttributedString(string: "\(myStringArr[0]):", attributes: myAttribute as [NSAttributedString.Key : Any] )
            let attrString = NSAttributedString(string: myStringArr[1], attributes: lastAttribute as [NSAttributedString.Key : Any])
            myString.append(attrString)
            label.attributedText = myString
        }
        else{
            label.text = title
        }
        label.tintColor = .black
        let imageview =  UIImageView(image: image)
        imageview.contentMode = .scaleAspectFit
        self.addSubview(label)
        self.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        imageview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset/2).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: image.size.width > 70 ? 70 : image.size.width).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: self.bounds.height - 10).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset).isActive = true
        label.trailingAnchor.constraint(equalTo: imageview.leadingAnchor, constant: -offset/2).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byClipping
        
    }
    
    
    
}

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func setNavigationBarItem() {
        
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        
    }
    
    
}


class circularBTN : UIButton{
    var circularLabel : UILabel?
    
    func circularLabel(title: String,color: UIColor){
        let width = self.bounds.size.height
        circularLabel = UILabel()
        circularLabel?.text = title
        circularLabel?.textColor = .white
        circularLabel?.font = UIFont.SF_Medium(14.0)
        circularLabel?.translatesAutoresizingMaskIntoConstraints = false
        circularLabel?.numberOfLines = 1
        circularLabel?.backgroundColor = color
        circularLabel?.textColor = color ==  UIColor.white ? .black : .white
        circularLabel?.widthAnchor.constraint(equalToConstant: width).isActive = true
        circularLabel?.heightAnchor.constraint(equalToConstant: width).isActive = true
        circularLabel?.layer.cornerRadius = width/2
        circularLabel?.clipsToBounds=true
        circularLabel?.textAlignment = .center
        circularLabel?.layer.borderColor = UIColor.lightGray.cgColor
        circularLabel?.layer.borderWidth = 0.5
        circularLabel?.layer.masksToBounds = true
        circularLabel?.minimumScaleFactor = 0.5
        self.addSubview(circularLabel!)
        circularLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        circularLabel?.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
    }
}





extension UIViewController {
    
    func setUpCenterViewNvigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        let container = UIImageView()
        container.contentMode = .scaleAspectFit
        container.backgroundColor = .clear
        container.frame = CGRect(x: 0, y: 0, width: 150, height: 45)
        container.image = UIImage(named: "ic_nav_logo")?.withInset(UIEdgeInsets(top: 5, left: 0, bottom: 3, right: 0))
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        container.layer.cornerRadius = 20
        self.navigationItem.titleView = container
        container.addTarget(target: self, action: #selector(backToHomeScreen))
        
    }
    
    
    func setupLeftnavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

      let image =  UIImage(named: "ic_back_nav")?.withInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        let buttonItem = UIBarButtonItem(image: image,
                                         landscapeImagePhone: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped(_:)))
        buttonItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = buttonItem
        
        
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any){
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backToHomeScreen () {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
//    func setupNav( title : String){
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
//        backButton.contentHorizontalAlignment = .leading
//        backButton.setImage(UIImage(named: ""), for: .normal)
//        backButton.tintColor = .white
//        backButton.addTarget(self, action: #selector(backTab), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        self.navigationItem.title = title
//        let clickableBtn = UIButton(type: .custom)
//        clickableBtn.backgroundColor = .clear
//        clickableBtn.frame = CGRect(x:(self.view.frame.size.width/3), y:0, width: 100, height: 50)
//        clickableBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
//        navigationController?.navigationBar.addSubview(clickableBtn)
//    }
//
//    @objc func goBack(){
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//
//    @IBAction func backTab(){
//        self.navigationController?.popViewController(animated: true)
//    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}


extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
}

extension UIViewController{
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
    
    
}
extension UIViewController {
    @objc func dialToDispatcher() {
        
        if let url = URL(string: "tel://\("")"),
           UIApplication.shared.canOpenURL(url) {
            Helper.showToast("Calling \(UserDefaults.getUserData?.firstName ?? "") \(UserDefaults.getUserData?.lastName ?? "")", delay: Helper.DELAY_LONG)
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            Helper.showToast("Invalid number", delay: Helper.DELAY_LONG)
        }
    }
}

extension UIButton{
    func dialNumber(number : String, name: String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            Helper.showToast("Calling "+name, delay: Helper.DELAY_LONG)
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            Helper.showToast("Invalid number", delay: Helper.DELAY_LONG)
        }
    }
}

extension String {
    
    func decode() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
}


extension UILabel{
    func setCharacterSpacing(_ spacing: CGFloat){
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
}



extension UIButton{
    
    func setupNextButton(title: String,
                         space: Double = 2.0,
                         cornerRadius:CGFloat = 10){
        self.titleLabel?.text = title
        self.layer.cornerRadius = cornerRadius 
        self.titleLabel?.font = UIFont.SF_Regular(14.0)
        self.clipsToBounds=true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
        self.backgroundColor = appColor.buttonBackColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.setCharacterSpacing(space)
    }
    
}


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 0.5) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}




///// string seprator
///
///
extension Collection {
    
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex else { return nil }
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
    
    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { let _ = formIndex(&index, offsetBy: n, limitedBy: endIndex) }
            return self[index]
        }
    }
    
    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
    
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}


extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(slide.mainViewController)
        //        }
        return viewController
    }
}

