//
//  RegistroViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {

    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
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
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func load(_ sender: Any) {
        self.validarRegistro()
    }
    
    @IBAction func btnTeclado(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func validarRegistro(){
    
        if self.txtNombres.text?.count == 0{
            self.crearAlertaController(titulo: "Error", mensaje: "Rellenar campo Nombres", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtApellidos.text?.count == 0{
            self.crearAlertaController(titulo: "Error", mensaje: "Rellenar campo Apellidos", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtEmail.text?.isValidEmail == false{
            self.crearAlertaController(titulo: "Error", mensaje: "Ingrese un Email", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtContraseña.text?.count == 0{
            self.crearAlertaController(titulo: "Error", mensaje: "Campo Contraseña vacio", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtRepetirContraseña.text != txtContraseña.text{
            self.crearAlertaController(titulo: "Error", mensaje: "Contraseña incorrecta", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtCarrera.text == ""{
            self.crearAlertaController(titulo: "Error", mensaje: "Rellenar campo Carrera", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtSede.text == ""{
            self.crearAlertaController(titulo: "Error", mensaje: "Rellenar campo Sede", tituloBoton: "Aceptar")
            return
        }
        
        if self.txtFechaNacimiento.text == ""{
            self.crearAlertaController(titulo: "Error", mensaje: "Rellenar campo Fecha Nacimiento", tituloBoton: "Aceptar")
            return
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        UIView.animate(withDuration: animationDuration) {
            self.constraintBottomScroll.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        UIView.animate(withDuration: animationDuration) {
            self.constraintBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }

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


