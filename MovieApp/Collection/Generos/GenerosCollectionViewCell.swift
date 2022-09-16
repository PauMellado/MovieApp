//
//  GenerosCollectionViewCell.swift
//  MovieApp
//
//  Created by Paulina Mellado Mateos on 09/09/22.
//

import UIKit

class GenerosCollectionViewCell:
    UICollectionViewCell {

    @IBOutlet weak var lbGeneros: UILabel!
    
    var selectGenero: Int?
   
    let recargarData = ViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    


}
