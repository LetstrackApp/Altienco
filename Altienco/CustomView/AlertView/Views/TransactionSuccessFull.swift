//
//  TransactionSuccessFull.swift
//  Altienco
//
//  Created by mac on 17/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Lottie
import UIKit
import AVFoundation
class TransactionSuccessFull : UIControl,ViewLoadable {
    
    static var nibName: String = xibName.transactionSuccessFull
    typealias complitionCloser = (Bool?) -> ()
    private var complition : complitionCloser?
    private var amount: String? = ""
    var player: AVAudioPlayer?
    
    @IBOutlet weak var animatorView: AnimationView!
    
    @IBOutlet weak var titleView: UILabel! {
        didSet {
            titleView.font = UIFont.SF_SemiBold(16)
        }
    }
    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var addAnother: UIButton! {
        didSet {
            addAnother.setupNextButton(title: lngConst.proceed,cornerRadius: 10)
            addAnother.titleLabel?.font = UIFont.SF_Regular(15)
            addAnother.addTarget(self, action: #selector(addAnotherCardAction(_:)), for: .touchUpInside)
        }
    }
    
    func configure(with amount: String,
                   complition : @escaping complitionCloser) ->Void{
        self.complition = complition
        self.amount = amount
        self.onLanguageChange(amount: amount)
        self.animateView()
    }
    
    
}


extension TransactionSuccessFull {
    
    func onLanguageChange(amount:String) {
        titleView.text = lngConst.wlecomeAddBalance
        addAnother.setTitle(lngConst.addAnotherCard, for: .normal)
        titleView.changeColor(mainString: lngConst.txnSucessMeg(amount: amount), stringToColor: amount, color: UIColor.init(0x0f4fca))
        
    }
    
    @IBAction func addAnotherCardAction(_ sender : Any){
        complition?(true)
    }
    
    func animateView() {
        let animation = Animation.named("txnSuccess")
        animatorView.animation = animation
        animatorView.contentMode = .scaleAspectFit
        animatorView.backgroundBehavior = .pauseAndRestore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.playSound()
            self?.animatorView.play(fromProgress: 0,
                                    toProgress: 1,
                                    loopMode: LottieLoopMode.playOnce,
                                    completion: { (finished) in
                if finished {
                    print("Animation Complete")
                } else {
                    print("Animation cancelled")
                }
            })
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
//            self?.animatorView.pause()
//        }
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "alertSound", ofType:"mpeg") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
