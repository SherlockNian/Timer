//
//  ViewController.swift
//  Timer
//
//  Created by Hong-Nian Lin on 2022/7/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var StartStop: UIButton!
    @IBOutlet weak var Reset: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    override func viewDidLoad()
    {
        print("hi")
        super.viewDidLoad()
        StartStop.setTitleColor(UIColor.blue, for: .normal)
    }

    @IBAction func ResetTap(_ sender: Any)
    {
        let alert = UIAlertController(title: "重新計數嗎?", message: "確定要清除嗎？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in self.count = 0
            self.timer.invalidate()
            self.TimerLabel.text = self.makeTimerString(hours: 0, minutes: 0, seconds: 0)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func StartStopTap(_ sender: Any)
    {
        if(timerCounting)
        {
            timerCounting = false
            timer.invalidate()
            StartStop.setTitle("開始", for: .normal)
            StartStop.setTitleColor(UIColor.blue, for: .normal)
        }
        else
        {
            timerCounting = true
            StartStop.setTitle("停止", for: .normal)
            StartStop.setTitleColor(UIColor.blue, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func TimerCounter() -> Void
    {
        print("\(count)")
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimerString(hours: time.0, minutes: time.1, seconds: time.2)
        TimerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600) , ((seconds % 3600) / 60),
               ((seconds % 3600) % 60))
    }
    func makeTimerString(hours: Int, minutes: Int, seconds: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
