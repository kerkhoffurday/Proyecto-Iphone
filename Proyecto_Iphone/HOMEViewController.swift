//
//  HOMEViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 10/9/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//


import UIKit
import Firebase

class HOMEViewController: UIViewController {

    @IBOutlet weak var tablePublicacion : UITableView!
    
    var objUsuario = UsuarioBE()
    
    var arrayPublicaciones = [PublicacionBE]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cargar()
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
            
            var arraySeguidores = [SeguidoresBE]()
            for objLike in result.childSnapshot(forPath: "seguidores").children{
                
                let parceSeg = (objLike as? DataSnapshot)?.value as? [String: Any]
                let idUsuario = parceSeg?["id"] as? String ?? ""
                arraySeguidores.append(SeguidoresBE(id: idUsuario))
            }
            
            arraySeguidores.append(SeguidoresBE(id: self.objUsuario.id))
            
            self.cargarPublicaciones(usuario : arraySeguidores)
        })
    }

    func cargarPublicaciones(usuario : [SeguidoresBE]){
        
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
            
            var arrayFilter = [PublicacionBE]()
            
            for item in usuario{
                for item2 in arrayData{
                    if item.id == item2.idUsuario{
                        arrayFilter.append(item2)
                    }
                }
            }

            self.arrayPublicaciones = arrayFilter
            self.tablePublicacion.reloadData()
        }) { (error) in
            
        }
    }
    
    @IBAction func btnTeclado(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnAgregarPublicacion(_ sender: Any) {
        self.performSegue(withIdentifier: "PublicacionesViewController", sender: self.objUsuario)
    }
    
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSeguidores(_ sender : UIButton){
        self.performSegue(withIdentifier: "SeguirPerfilesViewController", sender: nil)
    }
    
    @IBAction func btnPerfil(_ sender : UIButton){
        let publicacion = PublicacionBE(nombre: "", fehca: "", imagen: "", descripcion: "", likes: [LikesBE].init(), comentarios: [ComentariosBE].init(), stateLike: 0, state: "", idUsuario: self.objUsuario.id)
        self.performSegue(withIdentifier: "DetallePerfilViewController", sender: publicacion)
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
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
        }else if segue.identifier == "SeguirPerfilesViewController"{
            let vista = segue.destination as? SeguirPerfilesViewController
            vista?.objUsuario = self.objUsuario
        }
    }


}

extension HOMEViewController : UITableViewDataSource, UITableViewDelegate, TableViewCellsDelegate{
    
    func detallePerfil(_ clase: TableViewCells, objPublicacion: PublicacionBE) {
        self.performSegue(withIdentifier: "DetallePerfilViewController", sender: objPublicacion)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPublicaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaIdentifier = "TableViewCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: celdaIdentifier, for: indexPath) as! TableViewCells
        
        cell.objUser = self.objUsuario
        cell.delegate = self
        cell.objPublicacion = self.arrayPublicaciones[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrayPublicaciones[indexPath.row]
        self.performSegue(withIdentifier: "PublicacionDetalleViewController", sender: obj)
    }
}
