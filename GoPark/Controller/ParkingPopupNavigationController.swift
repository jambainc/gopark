//
//  ParkingPopupNavigationController.swift
//  GoPark
//
//  Created by Michael Wong on 23/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ParkingPopupNavigationController: UIViewController {
    
    
    @IBOutlet weak var viwPopupPanel: UIView!
    
    
    @IBOutlet weak var lblTypedesc: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAdjFromDay: UILabel!
    @IBOutlet weak var lblAdjToDay: UILabel!
    @IBOutlet weak var lblAdjStartTime: UILabel!
    @IBOutlet weak var lblAdjEndTime: UILabel!
    
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnNavigate(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnConfirm(_ sender: Any) {
        viwPopupPanel.isHidden = true
    }
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwillParkingPopupController(sender: UIStoryboardSegue){
        viwPopupPanel.isHidden = false
    }
    
    var selectedBayid = 0
    var selectedDuration = 0
    let dispatchGroup = DispatchGroup()
    var api2Decodables: [API2Decodable]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set button style
        btnNavigate.layer.cornerRadius = 5
        btnConfirm.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        // set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 0.5
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        
        requestDataFromAPI2(selectedId: selectedBayid)
        dispatchGroup.notify(queue: .main){
            self.lblTypedesc.text = self.api2Decodables[0].typedesc ?? "Unknown"
            self.lblDuration.text = String(self.api2Decodables[0].duration ?? 0) + " mins"
            
            if self.api2Decodables[0].adjFromDay == nil{
                self.lblAdjFromDay.text = "Unknown"
            }else{
                switch self.api2Decodables[0].adjFromDay {
                case 1:
                    self.lblAdjFromDay.text = "Monday"
                case 2:
                    self.lblAdjFromDay.text = "Tuesday"
                case 3:
                    self.lblAdjFromDay.text = "Wednesday"
                case 4:
                    self.lblAdjFromDay.text = "Thursday"
                case 5:
                    self.lblAdjFromDay.text = "Friday"
                case 6:
                    self.lblAdjFromDay.text = "Saturday"
                case 7:
                    self.lblAdjFromDay.text = "Sunday"
                default:
                    print("impossible")
                }
            }
            
            if self.api2Decodables[0].adjToDay == nil{
                self.lblAdjFromDay.text = "Unknown"
            }else{
                switch self.api2Decodables[0].adjToDay {
                case 1:
                    self.lblAdjToDay.text = "Monday"
                case 2:
                    self.lblAdjToDay.text = "Tuesday"
                case 3:
                    self.lblAdjToDay.text = "Wednesday"
                case 4:
                    self.lblAdjToDay.text = "Thursday"
                case 5:
                    self.lblAdjToDay.text = "Friday"
                case 6:
                    self.lblAdjToDay.text = "Saturday"
                case 7:
                    self.lblAdjToDay.text = "Sunday"
                default:
                    print("impossible")
                }
            }
            
            //self.lblAdjFromDay.text = String(self.api2Decodables[0].adjFromDay ?? 0)
            //self.lblAdjToDay.text = String(self.api2Decodables[0].adjToDay ?? 0)
            self.lblAdjStartTime.text = self.api2Decodables[0].adjStartTime ?? "Unknown"
            self.lblAdjEndTime.text = self.api2Decodables[0].adjEndTime ?? "Unknown"
        }
    }
    
    // Unwill method. It is called when Cancel button of ParkingPopupConfirmController is clicked.
    
    
    func requestDataFromAPI2(selectedId: Int){
        
        //enter
        self.dispatchGroup.enter()
        
        let urlStr = "http://52.65.239.40/parking.php?bayid=" + String(selectedId)
        
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                //let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                //print(jsons)
                
                //decode the data and store in an array call users
                let api2Decodables = try JSONDecoder().decode([API2Decodable].self, from: data!)
                //print(api2Decodables)
                self.api2Decodables = api2Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
            }.resume()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingNavigaitonToConfirmSegue"
        {
            let parkingPopupConfirmController = segue.destination as? ParkingPopupConfirmController
            parkingPopupConfirmController?.addMinute = selectedDuration - 5 // addMinute is the 5 minute before the duration.
            
        }
    }
 

}
