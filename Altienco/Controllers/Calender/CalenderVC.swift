//
//  CalenderVC.swift
//  LMRider
//
//  Created by APPLE on 11/01/21.
//  Copyright © 2021 Letstrack. All rights reserved.
//

//import UIKit
//import Koyomi
//
//class CalenderVC: UIViewController {
//
//    @IBOutlet weak var calenderView: UIView!{
//        didSet{
//            calenderView.layer.cornerRadius = 6.0
//            calenderView.clipsToBounds=true
//        }
//    }
//    @IBOutlet fileprivate weak var koyomi: Koyomi! {
//        didSet {
//            koyomi.circularViewDiameter = 0.2
//            koyomi.calendarDelegate = self
//            koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            koyomi.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
//            koyomi.style = .standard
//            koyomi.dayPosition = .center
//            koyomi.selectionMode = .sequence(style: .semicircleEdge)
//            koyomi.selectedStyleColor = UIColor.blue
//                
//            koyomi
//                .setDayFont(size: 14)
//                .setWeekFont(size: 10)
//            
//        }
//    }
//    @IBOutlet fileprivate weak var currentDateLabel: UILabel!
//    
//    fileprivate let invalidPeriodLength = 7
//    
//    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl! {
//        didSet {
//            segmentedControl.setTitle("Previous", forSegmentAt: 0)
//            segmentedControl.setTitle("Current", forSegmentAt: 1)
//            segmentedControl.setTitle("Next", forSegmentAt: 2)
//        }
//    }
//    
//   
//   
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        currentDateLabel.text = koyomi.currentDateString()
//    }
//    
//    @IBAction func tappedControl(_ sender: UISegmentedControl) {
//        let month: MonthType = {
//            switch sender.selectedSegmentIndex {
//            
//            case 0:  return .previous
//            case 1:  return .current
//                
//            default: return .next
//            }
//        }()
//        
//        koyomi.display(in: month)
//    }
//    
//    
//    
//    // Utility
//    func configureStyle(_ style: KoyomiStyle) {
//        koyomi.style = style
//        koyomi.reloadData()
//    }
//    
//    // MARK: - Utility -
//
//    fileprivate func date(_ date: Date, later: Int) -> Date {
//        var components = DateComponents()
//        components.day = later
//        return (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0)) ?? date
//    }
//}
//
//
//// MARK: - KoyomiDelegate -
//
//extension CalenderVC: KoyomiDelegate {
//    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
//        debugPrint("You Selected: \(date)")
//    }
//    
//    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
//        currentDateLabel.text = dateString
//    }
//    
//    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
//    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
//        debugPrint("-----", length, invalidPeriodLength)
//        koyomi.reloadData()
//        if length > invalidPeriodLength {
//            debugPrint("More than \(invalidPeriodLength) days are invalid period.")
//            return false
//        }
//        return true
//    }
//}
//
