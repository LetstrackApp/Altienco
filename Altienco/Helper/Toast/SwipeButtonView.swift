


import UIKit

/// DrawSwitchView
@IBDesignable class SwipeButtonView: UIView {
    
    @IBInspectable var radius: CGFloat = 0.0
    
    @IBInspectable var hint: String = ""
    
    @IBInspectable var image: UIImage?
    @IBInspectable var buttonColor: UIColor?
    
    private var isSuccess: Bool = false
    
    private var completionHandler: ((_ isSuccess: Bool) -> ())?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        setUp()
    }
    
    public var hintLabel: UILabel = UILabel()
    
    public var swipeImageView: UIImageView = UIImageView()
    public var swipeViewContainer: UIView = UIView()
    private func setUp() {
        
        hintLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(hintLabel)
        hintLabel.textColor = UIColor.white
        hintLabel.textAlignment = .center
        hintLabel.text = hint
        swipeViewContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: frame.height)
        swipeViewContainer.backgroundColor = buttonColor
        swipeImageView.image = image
        let width = swipeViewContainer.frame.width/2
        let height = swipeViewContainer.frame.height/2
        swipeImageView.frame = CGRect(x: swipeViewContainer.frame.width/2 - width/2, y: swipeViewContainer.frame.height/2 - height/2, width: width, height: height)
        swipeImageView.backgroundColor = UIColor.clear
        swipeImageView.layer.borderColor = UIColor.clear.cgColor
        swipeImageView.contentMode = .scaleAspectFit
        swipeViewContainer.addSubview(swipeImageView)
        self.addSubview(swipeViewContainer)
        swipeViewContainer.isUserInteractionEnabled = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first, swipeViewContainer == touch.view {
            let touchedPosition = touch.location(in: self)
            let alpha =  touchedPosition.x / frame.width
            swipeImageView.rotate(degrees: -(alpha) * 180)
            if touchedPosition.x > (frame.height/2) {
                swipeViewContainer.center = CGPoint(x: touchedPosition.x, y: swipeViewContainer.frame.midY)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, swipeViewContainer == touch.view {
            // let touchedPosition = touch.location(in: self)
            setToDefault()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first, swipeViewContainer == touch.view {
            setToDefault()
        }
    }
    
    /// Set to default
    private func setToDefault() {
        
        if self.bounds.maxX - swipeViewContainer.frame.width <= swipeViewContainer.center.x { // Move to final
            UIView.animate(withDuration: 0.0, animations: {
                self.swipeImageView.rotate(degrees: -180)
                self.swipeViewContainer.center.x = self.bounds.maxX - (self.swipeViewContainer.bounds.width/2)
            }) { (isFinished) in
                if isFinished {
                    self.isSuccess = true
                    if let complete = self.completionHandler {
                        complete(self.isSuccess)
                    }
                }
            }
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.swipeImageView.rotate(degrees: 0)
                self.swipeViewContainer.center.x = self.bounds.minX + (self .swipeViewContainer.bounds.width/2)
            }) { (isFinished) in
                if isFinished {
                    self.isSuccess = false
                    if let complete = self.completionHandler {
                        complete(self.isSuccess)
                    }}
            }
        }
        
    }
    
    public func resetButton(Reason: String){
        UIView.animate(withDuration: 0.5, animations: {
            self.swipeImageView.rotate(degrees: 0)
            self.swipeViewContainer.center.x = self.bounds.minX + (self .swipeViewContainer.bounds.width/2)
        })
        Helper.showToast(Reason, delay:Helper.DELAY_LONG)
        
    }
    
    public func handleAction(_ completed: @escaping((_ isSuccess: Bool) -> ()) ) {
        completionHandler = completed
    }
    
    public func updateHint(text: String) {
        hintLabel.text = text
    }
    
}


extension UIView {
    
    
    func rotate(degrees: CGFloat) {
        
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}
