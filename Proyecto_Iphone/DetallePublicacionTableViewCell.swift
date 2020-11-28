//
//  DetallePublicacionTableViewCell.swift
//  Proyecto_Iphone
//
//  Created by Patrick Kerkhoff on 11/23/20.
//  Copyright © 2020 Patrick Kerkhoff. All rights reserved.
//

import UIKit

class DetallePublicacionTableViewCell: UITableViewCell {

    @IBOutlet weak public var lblCorreo      : UILabel!
    @IBOutlet weak public var lblComentarios : UILabel!
    
    var objBE : ComentariosBE!{
        didSet{
            self.lblCorreo.text = self.objBE.correo
            self.lblComentarios.text = self.objBE.comentario
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
