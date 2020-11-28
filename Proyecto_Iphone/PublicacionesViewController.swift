//
//  PublicacionesViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class PublicacionesViewController: UIViewController{
  
    @IBOutlet weak var postFotoView     : UIImageView!
    @IBOutlet weak var txtDescripcion   : UITextField!
    @IBOutlet weak var txtImage         : UITextField!
    @IBOutlet weak var cargarIndicador  : UIActivityIndicatorView!
    
    var objUser = UsuarioBE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cargarFoto(_ sender : Any){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        picker.sourceType =  .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnPublicar(_ sender : UIButton){
        
        self.cargarIndicador.startAnimating()
        
        if self.txtDescripcion.text?.count ?? 0 == 0{
            self.cargarIndicador.stopAnimating()
            self.crearAlertaController(titulo: "ERROR", mensaje: "Ingrese una Descripcion", tituloBoton: "Aceptar") {}
            return
        }

        //1 Guardar foto de la imagen para luego obtener la url de la imagen y insertarla en mi publicacion
        self.guardarFotoServidor()
    }
    
    func guardarFotoServidor(){
        
        //Referencia del nombre donde se guardara mi imagen
        let publicar = Storage.storage().reference().child(self.txtImage.text ?? "")
        
        //El tipo de formato de la Imagen
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //if contiene una imagen entra al if en caso no tenga una imagen hace una publicacion sin imagen
        if let imagen = self.postFotoView.image?.jpegData(compressionQuality: 0.5){
            
            publicar.putData(imagen, metadata: metadata) { (store, error) in
                if error == nil{
                    publicar.downloadURL { (url, error) in
                        if error == nil{
                            self.insertarPublicacion(url: url?.absoluteURL.absoluteString ?? "")
                        }else{
                            self.crearAlertaController(titulo: "ERROR", mensaje: error?.localizedDescription ?? "", tituloBoton: "Aceptar") {}
                        }
                    }
                }else{
                    self.crearAlertaController(titulo: "ERROR", mensaje: error?.localizedDescription ?? "", tituloBoton: "Aceptar") {}
                }
            }
        }else{
            self.insertarPublicacion(url: "")
        }
    }
    
    func insertarPublicacion(url : String){
        var referenciaDB : DatabaseReference!
        referenciaDB = Database.database().reference().child("ISIL/Publicaciones").childByAutoId()
   
        //Formato de Fecha
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let agregar : [String : Any] = ["nombre" : self.objUser.correo,
                                        "descripcion" : self.txtDescripcion.text ?? "",
                                        "imagen" : url,
                                        "fecha" : dateFormatter.string(from: date)]
        
        referenciaDB.setValue(agregar) { (error, dataReference) in
            self.cargarIndicador.stopAnimating()
            if error == nil{
                referenciaDB.child("id").setValue(dataReference.key ?? "") { (error, data) in
                    if error == nil{
                        self.crearAlertaController(titulo: "Gracias", mensaje: "Publicacion creada", tituloBoton: "Aceptar") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else{
                self.cargarIndicador.stopAnimating()
                self.crearAlertaController(titulo: "ERROR", mensaje: error?.localizedDescription ?? "", tituloBoton: "Aceptar") {}
            }
        }
    }
    
}

extension PublicacionesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL{
            let ur = self.getURL().appendingPathComponent(imageURL.absoluteString ?? "")
            self.txtImage.text = ur.lastPathComponent
        }
        
        // me duevuele la imagen que seleccione
        if let imageNew = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.postFotoView.image = imageNew
        }
        
        //culmina al darle aceptar
        picker.dismiss(animated: true) {}
    }

    //Ontener la url de la imagen
    func getURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
