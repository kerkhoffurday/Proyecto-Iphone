//
//  SeguirPerfilesViewController.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class SeguirPerfilesViewController: UIViewController {

    @IBOutlet weak var tableUsuarios : UITableView!
    
    var objUsuario = UsuarioBE()
    var arrayUser = [UsuarioBE]()
    
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
            self.cargarUsuarios(usuario: arraySeguidores)
        })
    }
    
    func cargarUsuarios(usuario : [SeguidoresBE]){
        
        var referenciaDB : DatabaseReference!
        referenciaDB = Database.database().reference().child("ISIL").child("usuarios")
        referenciaDB.observe(DataEventType.value, with: { (result) in
            
            var arrayData = [UsuarioBE]()
            
            for obj in result.children{
                
                let objUsu = UsuarioBE()
                
                let parce = (obj as? DataSnapshot)?.value as? [String: Any]
                objUsu.nombre = parce?["nombre"] as? String ?? ""
                objUsu.apellido = parce?["apellido"] as? String ?? ""
                objUsu.correo = parce?["correo"] as? String ?? ""
                objUsu.id = parce?["id"] as? String ?? ""
                
                for item in usuario{
                    if item.id == objUsu.id{
                        objUsu.state = 1
                    }
                }
                arrayData.append(objUsu)
            }
            
            arrayData.removeAll(where: {$0.id == self.objUsuario.id})
            
            self.arrayUser = arrayData
            self.tableUsuarios.reloadData()
        }) { (error) in
            
        }
        
    }
    @IBAction func btnExit(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "DetallePerfilViewController"{
            let vista = segue.destination as? DetallePerfilViewController
            vista?.objUsuario = self.objUsuario
            vista?.objPublica = sender as? PublicacionBE
        }
    }
    

}

extension SeguirPerfilesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celdaIdentifier = "SeguirPerfilesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: celdaIdentifier, for: indexPath) as! SeguirPerfilesTableViewCell
        cell.objUser = self.objUsuario
        cell.objSeguidores = self.arrayUser[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrayUser[indexPath.row]
        let publicacion = PublicacionBE(nombre: "", fehca: "", imagen: "", descripcion: "", likes: [LikesBE].init(), comentarios: [ComentariosBE].init(), stateLike: 0, state: "", idUsuario: obj.id)
        
        self.performSegue(withIdentifier: "DetallePerfilViewController", sender: publicacion)
    }
    
}
