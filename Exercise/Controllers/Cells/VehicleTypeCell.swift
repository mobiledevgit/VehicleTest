//
//  VehicletypeCell.swift
//  Exercise
//

import UIKit

class VehicleTypeCell: UICollectionViewCell {

    @IBOutlet weak var carImageview: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(type: VehicleType) {
        carImageview.image = UIImage(named: type.image)
        carNameLabel.text = type.name
    }

}
