//
//  ScannerResultController.swift
//  GoPark
//
//  Created by Michael Wong on 29/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ScannerResultController: UIViewController {

    
    @IBOutlet weak var viwPopupPanel: UIView!
    @IBOutlet weak var lblIdentfier: UILabel!
    @IBOutlet weak var lblConfidence: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var identfier = ""
    var confidence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set button style
        btnCancel.layer.cornerRadius = 5
        // set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 0.5
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        
        
        self.lblIdentfier.text = identfier
        self.lblConfidence.text = confidence
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
