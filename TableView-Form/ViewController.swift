//
//  ViewController.swift
//  TableView-Form
//
//  Created by Rohit Prajapati on 07/03/19.
//  Copyright © 2019 Rohit Prajapati. All rights reserved.
//

import UIKit
import FSCalendar


class ViewController: UIViewController {
    
    
    @IBOutlet weak var daysScrollView: UIScrollView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var timeScrollview: UIScrollView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var xS_Val = 0
    var yS_Val = 0
    
    var xD_Val = 0
    var yD_Val = 0
    
    var xT_Val = 0
    var yT_Val = 0
    
    var width = 70
    var height = 70
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    private var datesRange: [Date]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        daysScrollView.tag = 1
        scrollview.tag = 2
        timeScrollview.tag = 3
        
        calendarView.allowsMultipleSelection = true
        calendarView.delegate = self
        
        for x in 0...100 {
            for y in 0...100 {
                let box = UIView(frame: CGRect(x: xS_Val, y: yS_Val, width: width, height: height))
                box.backgroundColor = .random()
                box.tag = (x * 10) + y
                
                scrollview.addSubview(box)
                xS_Val = xS_Val + width + 1
            }
            xS_Val = 0
            yS_Val = yS_Val + width + 1
        }

        let xContent = width * 100
        let yContent = width * 100
        scrollview.contentSize = CGSize(width: xContent, height: yContent)


        for _ in 0...100 {
            
            let box = UIView(frame: CGRect(x: xD_Val, y: 0, width: width, height: height))
            box.backgroundColor = .random()
            daysScrollView.addSubview(box)
            xD_Val = xD_Val + width + 1
           
        }
        
        let xDateContent = width * 100
        let yDateContent = 0
        daysScrollView.contentSize = CGSize(width: xDateContent, height: yDateContent)
      
        
        
        for _ in 0...100 {
            
            let box = UIView(frame: CGRect(x: 0, y:  yT_Val, width: width, height: height))
            box.backgroundColor = .random()
            timeScrollview.addSubview(box)
            yT_Val = yT_Val + width + 1
            
        }
        
        let xTimeContent = width * 100
        let yTimeContent = 0
        timeScrollview.contentSize = CGSize(width: xTimeContent, height: yTimeContent)
        
        
        
    }
    
    @IBAction func selectSlot(_ sender: Any) {
        
//        for view in self.scrollview.subviews {
//            print(view.tag)
//            if view.tag == 2 {
//                view.backgroundColor = .black
//            }
//
//        }
        
        
        UIView.animate(withDuration:  30) {
            self.view.layoutIfNeeded()
            self.bottomConstraint.constant = 0
        }
        
    }
    
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration:  30) {
            self.view.layoutIfNeeded()
            self.bottomConstraint.constant = -300
        }
    }
    
    
}


extension ViewController : FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            print("datesRange contains bbb: \(datesRange!)")
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                print("datesRange contains vvvv: \(datesRange!)")
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains ccc: \(datesRange!)")
            
            print(customDateFormatter(with: datesRange!))
            
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            
            print("datesRange contains xxx: \(datesRange!)")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            print("datesRange contains zzz: \(datesRange!)")
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}



//MARK: Extensions
extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollview.tag == 2 {
            daysScrollView.setContentOffset(CGPoint(x: scrollview.contentOffset.x, y: 0), animated: false)
            timeScrollview.setContentOffset(CGPoint(x: 0, y: scrollview.contentOffset.y), animated: false)
        }
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension ViewController {
    func customDateFormatter(with dateArray: [Date]) -> (firstDate: Date, secondDate: Date, month: String) {
        
        var firstDate = dateArray.first
        var lastDate = dateArray.last
        
        var dateFirstString: String?
        var dateSecondString: String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let datefirst = firstDate {
            dateFirstString = dateFormatter.string(from: datefirst)
        }
        
        if let dateSecond = lastDate {
            dateSecondString = dateFormatter.string(from: dateSecond)
        }
        
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        
        
        if let first_Date = dateFirstString {
            print("bnbbnb", first_Date)
            firstDate = dateFormatter2.date(from: first_Date)
        }
        
        if let second_Date = dateFirstString {
            lastDate = dateFormatter2.date(from: second_Date)

        }
        
        
        
        return(firstDate!, lastDate!, "March")
        
        
    }
}
