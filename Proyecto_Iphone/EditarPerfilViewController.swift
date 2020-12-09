//
//  EditarPerfilViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class EditarPerfilViewController: UIViewController {

    @IBOutlet weak var txtNombre : UITextField!
    @IBOutlet weak var txtApellido : UITextField!
    @IBOutlet weak var cargarIndicador  : UIActivityIndicatorView!
    
    var objDetalle : UsuarioBE!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNombre.text = self.objDetalle.nombre
        self.txtApellido.text = self.objDetalle.apellido

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func guardarPerfil(_ sender : UIButton){
        self.actualizar()
    }
    
    func actualizar(){
        self.cargarIndicador.startAnimating()
        if self.txtNombre.text?.count ?? 0 < 3{
            self.crearAlertaController(titulo: "Error", mensaje: "Ingrese un nombre correcto", tituloBoton: "Aceptar") {
                self.cargarIndicador.stopAnimating()
            }
            return
        }
        
        if self.txtApellido.text?.count ?? 0 < 3{
            self.crearAlertaController(titulo: "Error", mensaje: "Ingrese un apellido correcto", tituloBoton: "Aceptar") {
                self.cargarIndicador.stopAnimating()
            }
            return
        }
     
        var refPublica : DatabaseReference!
        refPublica = Database.database().reference().child("ISIL").child("Publicaciones")
        var refUser : DatabaseReference!
        refUser = Database.database().reference().child("ISIL").child("usuarios").child(self.objDetalle.id)
        
        let update : [String : Any] = ["nombre" : self.txtNombre.text ?? "",
                                       "apellido" : self.txtApellido.text ?? "",
                                       "correo" : self.objDetalle.correo,
                                       "id" : self.objDetalle.id]
        
        refUser.setValue(update) { (error, resut) in
            self.cargarIndicador.stopAnimating()
            if error == nil{
                refPublica.observe(DataEventType.value) { (result) in
                    
                    for obj in result.children{
                        let parce = (obj as? DataSnapshot)?.value as? [String: Any]
                        let idUsu = parce?["idUsuario"] as? String ?? ""
                        
                        if idUsu == self.objDetalle.id{
                            let id = parce?["id"] as? String ?? ""
                            print(id)
                            let nombre = "\(self.txtNombre.text ?? "") \(self.txtApellido.text ?? "")"
                            
                            result.ref.child(id).child("nombre").setValue(nombre)
                            
                        }
                    }
                    
                    self.crearAlertaController(titulo: "Correcto", mensaje: "Actualizacion Correcta", tituloBoton: "Aceptar") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }else{
                self.crearAlertaController(titulo: "Error", mensaje: "Actualizacion Incorrecto", tituloBoton: "Aceptar") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
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

