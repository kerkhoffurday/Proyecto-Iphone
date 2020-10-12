//
//  RecuperarContraseñaViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class RecuperarContrasen_aViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validarRecuperarContra() {
        if self.txtEmail.text?.isValidEmail == false{
            let alert = UIAlertController(title: "Error", message: "Ingrese un Email", preferredStyle: .alert)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .destructive) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
                
            }
        }else{
            print("Email correcto")
        }
    }
    
    @IBAction func load(_ sender: UIButton) {
        validarRecuperarContra()
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
