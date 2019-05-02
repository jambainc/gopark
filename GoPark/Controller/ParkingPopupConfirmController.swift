//
//  ParkingPopupConfirmController.swift
//  GoPark
//
//  Created by Michael Wong on 23/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import UserNotifications

class ParkingPopupConfirmController: UIViewController {

    @IBOutlet weak var viwPopupPanel: UIView!
    @IBOutlet weak var lblRemind: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancel(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //remover all notification
    }
    
    //minute for reminder
    var addMinute = 0 //this is the duration
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set button style
        btnCancel.layer.cornerRadius = 5
        //set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 0.5
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        
        //ask for notificaion Authorization request permission and set remind label
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            if granted == true{ //if notification is granted
                DispatchQueue.main.async {
                    self.lblRemind.text = "Will remind you at: " + self.caculateRemindTime(addMinute: self.addMinute)//caculate the remind time and set the Label
                    self.setReminder() //set the notification base on the addMinute
                }
            }else{ //if notification deny
                DispatchQueue.main.async {
                    self.lblRemind.text = "Without notification permission"
                }
            }
        }
        
    }
    
    func caculateRemindTime(addMinute: Int) -> String {
        let currentTime = Date()
        let calendar = Calendar.current
        let remindTime = calendar.date(byAdding: .minute, value: addMinute, to: currentTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: remindTime!)
    }
    
    func setReminder(){
        //set notification content
        let content = UNMutableNotificationContent()
        content.title = "Times up"
        content.subtitle = "You should take your car"
        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical
        //set a count down timer to trigger notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(addMinute), repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
