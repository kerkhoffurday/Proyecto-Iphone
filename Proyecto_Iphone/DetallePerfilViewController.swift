//
//  DetallePerfilViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class DetallePerfilViewController: UIViewController {

    @IBOutlet weak var tablePublicacion : UITableView!
    @IBOutlet weak var lblNombre : UILabel!
    @IBOutlet weak var lblApellido : UILabel!
    @IBOutlet weak var lblCorreo : UILabel!
    @IBOutlet weak var btnEditar : UIButton!
    
    var objUsuario = UsuarioBE()
    var objPublica  : PublicacionBE!
    var arrayPublica = [PublicacionBE]()
    var objDetalle  = UsuarioBE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cargar()
        // Do any additional setup after loading the view.
    }
    
    
    func cargar(){

        if self.objUsuario.id == self.objPublica.idUsuario{
            self.btnEditar.alpha = 1
        }else{
            self.btnEditar.alpha = 0
        }
        
        var refUser : DatabaseReference!
        refUser = Database.database().reference().child("ISIL").child("usuarios").child(self.objPublica.idUsuario)
        
        refUser.observe(DataEventType.value, with: { (result) in
            
            let parce = result.value as? [String : Any]
            let nombre = parce?["nombre"] as? String ?? ""
            let apellido = parce?["apellido"] as? String ?? ""
            let correo = parce?["correo"] as? String ?? ""
            let id = parce?["id"] as? String ?? ""
            
            self.objDetalle.nombre = nombre
            self.objDetalle.apellido = apellido
            self.objDetalle.correo  = correo
            self.objDetalle.id = id
            
            self.lblNombre.text = nombre
            self.lblApellido.text = apellido
            self.lblCorreo.text = correo
            
            self.cargarPublicaciones()
        })
    }

    func cargarPublicaciones(){
        
        var referenciaDB : DatabaseReference!
        referenciaDB = Database.database().reference().child("ISIL").child("Publicaciones")
        referenciaDB.observe(DataEventType.value, with: { (result) in
            
            var arrayData = [PublicacionBE]()
            
            for obj in result.children{
                
                let parce = (obj as? DataSnapshot)?.value as? [String: Any]
                let nombre = parce?["nombre"] as? String ?? ""
                let fehca = parce?["fecha"] as? String ?? ""
                let imagen = parce?["imagen"] as? String ?? ""
                let descripcion = parce?["descripcion"] as? String ?? ""
                let idUsuario   = parce?["idUsuario"] as? String
                let id  = parce?["id"] as? String ?? ""
                var likes       = [LikesBE]()
                var comentarios = [ComentariosBE]()
                
                for objLike in (obj as? DataSnapshot)?.childSnapshot(forPath: "likes").children ?? NSEnumerator.init(){
                    
                    let parceLike = (objLike as? DataSnapshot)?.value as? [String: Any]
                    let id = parceLike?["id"] as? String ?? ""
                    likes.append(LikesBE(id: id))
                }
                
                let filterLike = likes.filter({$0.id == self.objUsuario.id}).count //1 o 0
                
                
                for objComentario in (obj as? DataSnapshot)?.childSnapshot(forPath: "comentarios").children ?? NSEnumerator.init(){
                    
                    let parceComent = (objComentario as? DataSnapshot)?.value as? [String: Any]
                    let id          = parceComent?["id"] as? String ?? ""
                    let comentario  = parceComent?["comentario"] as? String ?? ""
                    let correo      = parceComent?["correo"] as? String ?? ""
                    
                    comentarios.append(ComentariosBE(id: id,comentario: comentario, correo: correo))
                }
                
                arrayData.append(PublicacionBE(nombre: nombre, fehca: fehca, imagen: imagen, descripcion: descripcion, likes: likes, comentarios: comentarios,stateLike: filterLike,state: id, idUsuario: idUsuario ?? ""))
            }
            
            let arrayFiltro = arrayData.filter({$0.idUsuario == self.objPublica.idUsuario})
            
            self.arrayPublica = arrayFiltro
            self.tablePublicacion.reloadData()
        }) { (error) in
            
        }
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditar(_ sender : UIButton){
        self.performSegue(withIdentifier: "EditarPerfilViewController", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PublicacionesViewController"{
            let vista = segue.destination as? PublicacionesViewController
            vista?.objUser = self.objUsuario
        }else if segue.identifier == "PublicacionDetalleViewController"{
            let vista = segue.destination as? PublicacionDetalleViewController
            vista?.objUsuario = self.objUsuario
            vista?.objPublicacion = sender as? PublicacionBE
        }else if segue.identifier == "DetallePerfilViewController"{
            let vista = segue.destination as? DetallePerfilViewController
            vista?.objUsuario = self.objUsuario
            vista?.objPublica = sender as? PublicacionBE
        }else if segue.identifier == "EditarPerfilViewController"{
            let vista = segue.destination as? EditarPerfilViewController
            vista?.objDetalle = self.objDetalle
        }
    }

}

extension DetallePerfilViewController : UITableViewDataSource, UITableViewDelegate, TableViewCellsDelegate{
    
    func detallePerfil(_ clase: TableViewCells, objPublicacion: PublicacionBE) {
        self.performSegue(withIdentifier: "DetallePerfilViewController", sender: objPublicacion)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPublica.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaIdentifier = "TableViewCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: celdaIdentifier, for: indexPath) as! TableViewCells
        
        cell.objUser = self.objUsuario
        cell.delegate = self
        cell.objPublicacion = self.arrayPublica[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrayPublica[indexPath.row]
        self.performSegue(withIdentifier: "PublicacionDetalleViewController", sender: obj)
    }
}
