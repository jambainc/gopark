//
//  SettingController.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class SettingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //define the table view cell icon name and title
    let cellIcons = ["language","aboutUs"]
    let cellTitles = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingController_language", comment: ""),
                    LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingController_aboutUs", comment: "")]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingController_title", comment: "")
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingControllerTableViewCell", for: indexPath) as! SettingControllerTableViewCell
        cell.imgCellIcon.image = UIImage(named: cellIcons[indexPath.row])
        cell.lblCellTitle.text = cellTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "SettingToLanguageSegue", sender: nil)
        case 1:
            performSegue(withIdentifier: "SettingToAboutUsSegue", sender: nil)
        default:
            print("Error")
        }
        tableView.deselectRow(at: indexPath, animated: true) //remove the row selection after tapping on the cell
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
