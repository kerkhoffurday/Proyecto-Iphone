//
//  PublicacionDetalleViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class PublicacionDetalleViewController: UIViewController {

    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    @IBOutlet weak var txtCometario: UITextField!
    @IBOutlet weak var tblComentario: UITableView!
    @IBOutlet weak var cargarIndicador  : UIActivityIndicatorView!
    @IBOutlet weak public var lblNombre : UILabel!
    @IBOutlet weak public var lblFecha  : UILabel!
    @IBOutlet weak public var imagePu   : UIImageView!
    @IBOutlet weak public var imgLike   : UIImageView!
    @IBOutlet weak public var lblDescripcion : UILabel!
    @IBOutlet weak public var lblLikes  : UILabel!
    @IBOutlet weak public var lblComentarios : UILabel!
    @IBOutlet weak public var constraintImage : NSLayoutConstraint!
    
    var objUsuario = UsuarioBE()
    var objPublicacion : PublicacionBE?
    var arrayComentarios = [ComentariosBE]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cargar()
        self.cargarComentario()
        // Do any additional setup after loading the view.
    }
    
    func cargar(){
        var refUser : DatabaseReference!
        refUser = Database.database().reference().child("ISIL").child("usuarios").child(self.objUsuario.id)
        
        refUser.observe(DataEventType.value, with: { (result) in
            let parce = result.value as? [String : Any]
            let nombre = parce?["nombre"] as? String ?? ""
            let apellido = parce?["apellido"] as? String ?? ""
            let correo = parce?["correo"] as? String ?? ""
            let id = parce?["id"] as? String ?? ""
            
            self.objUsuario.nombre = nombre
            self.objUsuario.apellido = apellido
            self.objUsuario.correo  = correo
            self.objUsuario.id = id
        })
        self.cargarDetalle()
    }
    
    func cargarDetalle(){
        if self.objPublicacion?.img ?? "" == ""{
            self.constraintImage.constant = 0
        }else{
            self.constraintImage.constant = 130
        }
        //si mi state like es 1 ya dio Like pero si es 0 no le dio like
        if self.objPublicacion?.stateLike ?? 0 == 1{
            self.imgLike.image = UIImage(named: "corazonRojo")
        }else{
            self.imgLike.image = UIImage(named: "corazon")
        }
        
        self.lblNombre.text = self.objPublicacion?.nombre_usuario ?? ""
        self.lblFecha.text = self.objPublicacion?.fecha ?? ""
        self.imagePu.downloadImageInURLString(self.objPublicacion?.img ?? "", placeHolderImage: nil) { (image, url) in
            if self.objPublicacion?.img ?? "" == url{
                self.imagePu.image = image
            }
        }
        self.lblDescripcion.text = self.objPublicacion?.descripcion ?? ""
        self.lblLikes.text = "\(self.objPublicacion?.likes.count ?? 0) Likes"
        self.lblComentarios.text = "\(self.objPublicacion?.comentarios.count ?? 0) Comentarios"
    }
    
    func cargarComentario(){
        var referenciaDB : DatabaseReference!
        let url = "ISIL/Publicaciones/\(self.objPublicacion?.statePublicacion ?? "")/comentarios"
        referenciaDB = Database.database().reference().child(url)
        referenciaDB.observe(DataEventType.value, with: { (result) in
            
            var arrayData = [ComentariosBE]()
            
            for obj in result.children{
    
                let parceComent = (obj as? DataSnapshot)?.value as? [String: Any]
                let id          = parceComent?["id"] as? String ?? ""
                let comentario  = parceComent?["comentario"] as? String ?? ""
                let correo      = parceComent?["correo"] as? String ?? ""
                arrayData.append(ComentariosBE(id: id,comentario: comentario, correo: correo))
            }
            
            self.arrayComentarios = arrayData
            
            self.lblComentarios.text = "\(self.arrayComentarios.count) Comentarios"
            self.tblComentario.reloadData()
        }) { (error) in
            
        }
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
    
    @IBAction func btnTeclado(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAgregarComentario(_ sender : UIButton){
        var referenciaDB : DatabaseReference!
        let url = "ISIL/Publicaciones/\(self.objPublicacion?.statePublicacion ?? "")/comentarios"
        referenciaDB = Database.database().reference().child(url).childByAutoId()
  
        let agregar : [String : Any] = ["id" : "",
                                        "correo" : self.objUsuario.nombre + " " + self.objUsuario.apellido ,
                                        "comentario" : self.txtCometario.text ?? ""]
        
        referenciaDB.setValue(agregar) { (error, dataReference) in
            self.cargarIndicador.stopAnimating()
            if error == nil{
                referenciaDB.child("id").setValue(dataReference.key ?? "") { (error, data) in
                    if error == nil{
                        self.txtCometario.text = "" 
                    }
                }
            }else{
                self.cargarIndicador.stopAnimating()
                self.crearAlertaController(titulo: "ERROR", mensaje: error?.localizedDescription ?? "", tituloBoton: "Aceptar") {}
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
            self.constraintBottomScroll.constant = 10
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

extension PublicacionDetalleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayComentarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DetallePublicacionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DetallePublicacionTableViewCell
        cell.objBE = self.arrayComentarios[indexPath.row]
        return cell
    }
}
