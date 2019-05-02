//
//  ListController.swift
//  GoPark
//
//  Created by Michael Wong on 23/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//
// http://52.65.239.40/top30.php?lat=144.907744261925&long=-37.829756373939

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let dispatchGroup = DispatchGroup()
    var api3Decodables: [API3Decodable]!
    
    override func viewWillAppear(_ animated: Bool) {
        //tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ListController_title", comment: "")
        
        //readDataFromFile()
        requestDataFromAPI3()
        
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData() // reload tableview data after http request
        }
    }
    
    func readDataFromFile(){
        let path = Bundle.main.path(forResource: "list", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        //let jsons = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        //print(jsons)
        let api3Decodables = try! JSONDecoder().decode([API3Decodable].self, from: data)
        self.api3Decodables = api3Decodables
    }
    
    func requestDataFromAPI3(){
        //enter
        self.dispatchGroup.enter()
        
        let url = URL(string: "http://52.65.239.40/distance.php?lat=144.907744261925&long=-37.829756373939")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                if data == nil {
                    return
                }
                let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsons)
                
                //decode the data and store in an array call users
                let api3Decodables = try JSONDecoder().decode([API3Decodable].self, from: data!)
                //print(api3Decodables)
                self.api3Decodables = api3Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
            }.resume()
    }
    
    //MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if api3Decodables == nil{
            return 0
        }else{
            return api3Decodables.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListControllerTableViewCell", for: indexPath) as! ListControllerTableViewCell
        cell.lblSign.text = api3Decodables[indexPath.row].sign
        cell.lblAddress.text = api3Decodables[indexPath.row].address
        let travelTimeSecond = api3Decodables[indexPath.row].traveltime
        let travelTimeMinute: Int = travelTimeSecond!/60
        let travelTime: String = "Traveling time: " + String(travelTimeMinute) + " Mins"
        cell.lblTravelTime.text = travelTime
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let bayid = 2510
        let bayid = api3Decodables[indexPath.row].bayid
        let parkingController = self.tabBarController?.viewControllers![0].childViewControllers.first as! ParkingController
        parkingController.showAnnotaitonSelectedFromList(bayid: bayid!)
        self.tabBarController?.selectedIndex = 0
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
