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
        self.cargarPublicaciones()
        // Do any additional setup after loading the view.
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
                
                arrayData.append(PublicacionBE(nombre: nombre, fehca: fehca, imagen: imagen, descripcion: descripcion, likes: likes, comentarios: comentarios,stateLike: filterLike,state: id))
            }
            
            self.arrayPublicaciones = arrayData
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
        }
    }


}

extension HOMEViewController : UITableViewDataSource, UITableViewDelegate{
    
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
        cell.objPublicacion = self.arrayPublicaciones[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrayPublicaciones[indexPath.row]
        self.performSegue(withIdentifier: "PublicacionDetalleViewController", sender: obj)
    }
}
