//
//  RegistroViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistroViewController: UIViewController {

    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var txtRepetirContraseña: UITextField!
    
    
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
    
        if self.txtContraseña.text != self.txtRepetirContraseña.text{
            self.crearAlertaController(titulo: "Error", mensaje: "Contraseñas no son iguales", tituloBoton: "Aceptar"){
                
            }
            return
        }
        
        Auth.auth().createUser(withEmail: self.txtEmail.text ?? "", password: self.txtRepetirContraseña.text ?? "") { (result, error) in
            if error == nil{
                
                var referenciaDB : DatabaseReference!
                referenciaDB = Database.database().reference().child("ISIL").child("usuarios")
                
                let armado : [String : Any] = ["nombre" : self.txtEmail.text ?? "",
                                               "correo" : self.txtEmail.text ?? "",
                                               "apellido" : "",
                                               "id" : result?.user.uid ?? ""]
                
                referenciaDB.child(result?.user.uid ?? "").setValue(armado) { (error, result) in
                    if error == nil{
                        self.crearAlertaController(titulo: "Felicidades!", mensaje: "Usuario creado correctamente", tituloBoton: "Aceptar"){
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        
                    }
                }
    
            }else{
                self.crearAlertaController(titulo: "Error", mensaje: error?.localizedDescription ?? "", tituloBoton: "Aceptar"){
                    
                }
            }
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


