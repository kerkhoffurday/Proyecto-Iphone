//
//  HOMEViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class HOMEViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnTeclado(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
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
