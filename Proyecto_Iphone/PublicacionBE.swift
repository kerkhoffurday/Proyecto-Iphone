//
//  File.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import Foundation

class PublicacionBE{
    
    var stateLike        : Int
    var statePublicacion : String
    var nombre_usuario  : String
    var fecha: String
    var img: String
    var descripcion: String
    var likes = [LikesBE]()
    var comentarios = [ComentariosBE]()
    var idUsuario  : String

    init(nombre: String, fehca: String, imagen: String, descripcion: String, likes: [LikesBE], comentarios:[ComentariosBE],stateLike : Int, state : String,idUsuario : String){
        self.nombre_usuario = nombre
        self.fecha = fehca
        self.img = imagen
        self.descripcion = descripcion
        self.likes = likes
        self.comentarios = comentarios
        self.statePublicacion = state
        self.stateLike = stateLike
        self.idUsuario  = idUsuario
    }
    
}

class LikesBE{

    var id = ""

    init(id: String){
        self.id = id
    }
}

class ComentariosBE{

    var id = ""
    var comentario = ""
    var correo = ""
    init(id: String, comentario : String, correo : String){
        self.id = id
        self.comentario = comentario
        self.correo = correo
    }
}

class UsuarioBE: NSObject{
    var correo = ""
    var comentario = ""
    var id = ""
    var like = 0
    var nombre = ""
    var apellido = ""
    var state = 0
}

class SeguidoresBE: NSObject{
    
    var id = ""
    init(id: String){
        self.id = id
    }
}
