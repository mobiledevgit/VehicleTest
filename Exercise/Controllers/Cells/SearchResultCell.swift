//
//  SearchResultCell.swift
//  Exercise
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(name: String?, value: String?) {
        nameLabel.text = name
        valueLabel.text = value
    }
    
}
