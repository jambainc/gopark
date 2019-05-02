//
//  ReferenceController.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit


class ReferenceController: UIViewController {

    @IBOutlet weak var viwCategory1: UIImageView!
    @IBOutlet weak var viwCategory2: UIImageView!
    @IBOutlet weak var viwCategory3: UIImageView!
    @IBOutlet weak var viwCategory4: UIImageView!
    @IBOutlet weak var viwCategory5: UIImageView!
    
    
    //define a var to store which card user choose and used for navigation segue
    var referenceToDetailsSegueData = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_title", comment: "")
        
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            viwCategory1.image = UIImage(named: "parkSignCategory1en")
            viwCategory2.image = UIImage(named: "parkSignCategory2en")
            viwCategory3.image = UIImage(named: "parkSignCategory3en")
            viwCategory4.image = UIImage(named: "parkSignCategory4en")
            viwCategory5.image = UIImage(named: "parkSignCategory5en")
        }else{
            viwCategory1.image = UIImage(named: "parkSignCategory1cn")
            viwCategory2.image = UIImage(named: "parkSignCategory2cn")
            viwCategory3.image = UIImage(named: "parkSignCategory3cn")
            viwCategory4.image = UIImage(named: "parkSignCategory4cn")
            viwCategory5.image = UIImage(named: "parkSignCategory5cn")
        }
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture1))
        self.viwCategory1.addGestureRecognizer(gesture1)
        self.viwCategory1.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture2))
        self.viwCategory2.addGestureRecognizer(gesture2)
        self.viwCategory2.isUserInteractionEnabled = true
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture3))
        self.viwCategory3.addGestureRecognizer(gesture3)
        self.viwCategory3.isUserInteractionEnabled = true
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture4))
        self.viwCategory4.addGestureRecognizer(gesture4)
        self.viwCategory4.isUserInteractionEnabled = true
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture5))
        self.viwCategory5.addGestureRecognizer(gesture5)
        self.viwCategory5.isUserInteractionEnabled = true
    }
    
    //the 5 card onclick listener
    @objc func performGesture1(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 0
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture2(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 1
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture3(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 2
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture4(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 3
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture5(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 4
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReferenceToDetailsSegue"
        {
            let referenceDetailsController = segue.destination as? ReferenceDetailsController
            referenceDetailsController?.categoryNum = referenceToDetailsSegueData
        }
    }
    

}
