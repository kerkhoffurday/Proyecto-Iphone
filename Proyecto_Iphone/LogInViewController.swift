//
//  LogInViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var txtcontraseña: UITextField!
    @IBOutlet weak var txtusuario: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadSesion(){
        if self.txtusuario.text?.isValidEmail == false{
            let alert = UIAlertController(title: "Error", message: "Ingrese un usuario", preferredStyle: .alert)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .destructive) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
                
            }
        }else{
            print("Usuario correcto")
        }
        
        if self.txtcontraseña.text == ""{
            let alert = UIAlertController(title: "Error", message: "Ingrese una contraseña", preferredStyle: .alert)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .destructive) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
                
            }
        }else{
            print("Contraseña correcta")
        }
    }
    
    @IBAction func btnIniciarSesion(_ sender: UIButton) {
        loadSesion()
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

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
