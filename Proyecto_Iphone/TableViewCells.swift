//
//  TableViewCells.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class TableViewCells: UITableViewCell{
    
    @IBOutlet weak public var lblNombre : UILabel!
    @IBOutlet weak public var lblFecha  : UILabel!
    @IBOutlet weak public var imagePu   : UIImageView!
    @IBOutlet weak public var imgLike   : UIImageView!
    @IBOutlet weak public var lblDescripcion : UILabel!
    @IBOutlet weak public var lblLikes  : UILabel!
    @IBOutlet weak public var lblComentarios : UILabel!
    @IBOutlet weak public var constraintImage : NSLayoutConstraint!
    
    public var objUser = UsuarioBE()
    public var objPublicacion: PublicacionBE!{
        didSet{
            self.updateData()
        }
    }
    
    
    func updateData(){
        //Si mi imagen no tiene una url la imagen de achica  0 pero si tiene una url se queda en 130 de tamaño
        if self.objPublicacion.img == ""{
            self.constraintImage.constant = 0
        }else{
            self.constraintImage.constant = 130
        }
        //si mi state like es 1 ya dio Like pero si es 0 no le dio like
        if self.objPublicacion.stateLike == 1{
            self.imgLike.image = UIImage(named: "corazonRojo")
        }else{
            self.imgLike.image = UIImage(named: "corazon")
        }
        
        self.lblNombre.text = self.objPublicacion.nombre_usuario
        self.lblFecha.text = self.objPublicacion.fecha
        self.imagePu.downloadImageInURLString(self.objPublicacion.img, placeHolderImage: nil) { (image, url) in
            if self.objPublicacion.img == url{
                self.imagePu.image = image
            }
        }
        self.lblDescripcion.text = self.objPublicacion.descripcion
        self.lblLikes.text = "\(self.objPublicacion.likes.count) Likes"
        self.lblComentarios.text = "\(self.objPublicacion.comentarios.count) Comentarios"
    }
    
    @IBAction func btnLike(_ sender : Any){
        if self.objPublicacion.stateLike == 1 {
            self.enviarLike(state: false)
        }else{
            self.enviarLike(state: true)
        }
    }
 
    func enviarLike(state : Bool){
        var referenciaDB : DatabaseReference!
        
        let url = "ISIL/Publicaciones/\(self.objPublicacion.statePublicacion)/likes/\(self.objUser.id)"
        
        referenciaDB = Database.database().reference().child(url)

        let agregar : [String : Any] = ["id" : self.objUser.id]
        
        if state == true {
            referenciaDB.setValue(agregar) { (error, dataReference) in
                
            }
        }else{
            referenciaDB.setValue(nil) { (error, dataReference) in
                
            }
        }
    }
}
