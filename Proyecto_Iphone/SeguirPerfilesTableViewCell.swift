//
//  SeguirPerfilesTableViewCell.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit
import Firebase

class SeguirPerfilesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNombre : UILabel!
    @IBOutlet weak var btnSeguir : UIButton!
    
    var objUser = UsuarioBE()
    var objSeguidores : UsuarioBE!{
        didSet{
            self.lblNombre.text = self.objSeguidores.nombre + " " + self.objSeguidores.apellido
            if self.objSeguidores.state == 0 {
                self.btnSeguir.setTitleColor(.link, for: .normal)
                self.btnSeguir.setTitle("Seguir", for: .normal)
            }else{
                self.btnSeguir.setTitleColor(.red, for: .normal)
                self.btnSeguir.setTitle("Seguido", for: .normal)
            }
        }
    }
    
    @IBAction func btnAgregar(_ sender : UIButton){
        
        var referenciaDB : DatabaseReference!
        let url = "ISIL/usuarios/\(self.objUser.id)/seguidores/\(self.objSeguidores.id)"
        referenciaDB = Database.database().reference().child(url)
        
        if self.objSeguidores.state == 0{
            referenciaDB.child("id").setValue(self.objSeguidores.id)
        }else{
            referenciaDB.setValue(nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
