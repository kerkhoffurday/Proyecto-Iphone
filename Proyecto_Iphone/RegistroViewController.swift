//
//  RegistroViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {

    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var txtRepetirContraseña: UITextField!
    @IBOutlet weak var txtCarrera: UITextField!
    @IBOutlet weak var txtSede: UITextField!
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validarRegistro(){
        if self.txtNombres.text == ""{
            let alert = UIAlertController(title: "Error", message: "Rellenar campo Nombres", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Nombres correcto")
        }
        
        if self.txtApellidos.text == ""{
            let alert = UIAlertController(title: "Error", message: "Rellenar campo Apellidos", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Apellidos correcto")
        }
        
        if self.txtEmail.text?.isValidEmail == false{
            let alert = UIAlertController(title: "Error", message: "Ingrese un Email", preferredStyle: .alert)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
                
            }
        }else{
            print("Email correcto")
        }
        
        if self.txtContraseña.text == ""{
            let alert = UIAlertController(title: "Error", message: "Campo Contraseña vacio", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Contraseña correcta")
        }
        
        if self.txtRepetirContraseña.text != txtContraseña.text{
            let alert = UIAlertController(title: "Error", message: "Contraseña incorrecta", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Contraseña correcta")
        }
        
        if self.txtCarrera.text == ""{
            let alert = UIAlertController(title: "Error", message: "Rellenar campo Carrera", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Carrera correcto")
        }
        
        if self.txtSede.text == ""{
            let alert = UIAlertController(title: "Error", message: "Rellenar campo Sede", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Sede correcto")
        }
        
        if self.txtFechaNacimiento.text == ""{
            let alert = UIAlertController(title: "Error", message: "Rellenar campo Fecha Nacimiento", preferredStyle: .actionSheet)
            let botonAlert = UIAlertAction(title: "Aceptar", style: .cancel) { (action) in
                print("Acabas de presionar la acción Aceptar")
            }
            alert.addAction(botonAlert)
            self.present(alert, animated: true) {
            }
        }else{
            print("Fecha de Nacimiento correcto")
        }
    }
    
    @IBAction func load(_ sender: Any) {
        self.validarRegistro()
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


