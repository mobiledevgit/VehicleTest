//
//  SearchResultHeaderView.swift
//  Exercise
//

import UIKit

class SearchResultHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func configView(title: String?, value: String?) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
