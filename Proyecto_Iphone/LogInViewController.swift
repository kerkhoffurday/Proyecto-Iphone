//
//  LogInViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var txtcontraseña    : UITextField!
    @IBOutlet weak var txtusuario       : UITextField!
    @IBOutlet weak var cargarIndicador  : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    @IBAction func btnIniciarSesion(_ sender: UIButton) {
        self.loadSesion()
    }
    
    @IBAction func btnTeclado(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func loadSesion(){
        let objUsuario = UsuarioBE()
        self.cargarIndicador.startAnimating()
        
        Auth.auth().signIn(withEmail: self.txtusuario.text ?? "", password: self.txtcontraseña.text ?? "") { (result, Error) in
            self.cargarIndicador.stopAnimating()
            if Error == nil {
                objUsuario.nombre = ""  
                objUsuario.correo = self.txtusuario.text ?? ""
                objUsuario.id = result?.user.uid ?? ""
                print("Ingreso correctamente")
                self.performSegue(withIdentifier: "HOMEViewController", sender: objUsuario)
            }else{
                self.crearAlertaController(titulo: "Error", mensaje: Error?.localizedDescription ?? "", tituloBoton: "Aceptar") {
                    
                }
            }
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HOMEViewController"{
            let controller = segue.destination as? HOMEViewController
            controller?.objUsuario = sender as? UsuarioBE ?? UsuarioBE.init()
        }
    }
    

}

extension UIViewController {

    //    MARK: - Creamos una funcion general de alerta, esta funcion se podra llamar en cualquier controlador
    //    MARK: - Asi reusamos codigo y no creamos una y otra ves el mismo codigo
    
    func crearAlertaController(titulo : String, mensaje : String, tituloBoton : String, completado  Completado: @escaping (() -> Void)){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let botonAlerta = UIAlertAction(title: tituloBoton, style: .cancel) { (Action) in
            Completado()
        }
        alert.addAction(botonAlerta)
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
