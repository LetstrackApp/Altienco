//
//  SelectLanguageVC.swift
//  LMDispatcher
//
//  Created by APPLE on 10/09/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import DropDown
import Localize_Swift
var lngConst = langguageConstent.init()
final class SelectLanguageVC: UIViewController {
    
    private var viewModel : LanguageViewModel?
    @IBOutlet weak var languageTitle: UILabel!{
        didSet{
            languageTitle.font = UIFont.SF_Medium(15.0)
            languageTitle.text = lngConst.chooseLanguage.capitalized            
        }
    }
    @IBOutlet weak var SelectLanguageButton: UIButton!{
        didSet{
            SelectLanguageButton.titleLabel?.font = UIFont.SF_Regular(15.0)
            SelectLanguageButton.layer.cornerRadius = 5
            SelectLanguageButton.layer.borderWidth = 0.6
            SelectLanguageButton.layer.borderColor = UIColor.black.cgColor
            SelectLanguageButton.clipsToBounds=true
        }
    }
    @IBOutlet weak var languageContainer: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.languageContainer.roundCorners(with: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 15.0)
            }
            
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.setTitle(lngConst.proceed, for: .normal)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.titleLabel?.font = UIFont.SF_Regular(15.0)
            nextButton.clipsToBounds=true
            nextButton.backgroundColor = appColor.buttonBackColor
            nextButton.setTitleColor(.white, for: .normal)
//            DispatchQueue.main.async {
//                self.nextButton.dropShadow(color: .white, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 3, scale: true)
//            }
        }
    }
    
    
    // dropdown
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateModel()
        //        LoaderOverlay.shared.show()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initiateModel() {
        viewModel = LanguageViewModel()
        viewModel?.getLanguage()
        viewModel?.language.bind(listener: { (val) in
            self.initLanguage()
        })
        
    }
    
    func initLanguage()
    {
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = viewModel?.language.value.map({ $0.language }) as? [String] ?? []
        Localize.setCurrentLanguage("en")
        lngConst = langguageConstent.init()
    }
    
    
    private func showDropDown(view : UIButton){
        dropDown.anchorView = self.SelectLanguageButton
        dropDown.direction = .any
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0
            {
                self.SelectLanguageButton.setTitle("   \(item)", for: .normal)
                Localize.setCurrentLanguage("en")
                lngConst = langguageConstent.init()
            }
            else{
                self.SelectLanguageButton.setTitle("   \(item)", for: .normal)
                Localize.setCurrentLanguage("hi")
                lngConst = langguageConstent.init()
            }
            self.languageTitle.text = "\(lngConst.langTitle.capitalized)"
            self.nextButton.setTitle("\(lngConst.next.capitalized)", for: .normal)
            
        }
        dropDown.show()
        
    }
    
    
    
    @IBAction func SelectDropDown(_ sender: Any) {
        showDropDown(view: SelectLanguageButton)
    }
//        if viewModel?.language.value.isEmpty == false{
            
//        }
//        else{
//            viewModel?.getLanguage()
//        }
    
    
    
    @IBAction func NEXTBUTTON(_ sender: Any) {
        let vc = CountrySelectionVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}




