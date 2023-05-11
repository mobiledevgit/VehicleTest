//
//  SelectionTypeViewController.swift
//  Exercise
//

import UIKit

enum SelectionType {
    case make
    case model
    case year
    case maxPrice
    
    var notSetTitle: String {
        switch self {
        case .make:
            return "All makes"
        case .model:
            return "All models"
        case .year:
            return "Any"
        case .maxPrice:
            return "No max price"
        }
    }
}

struct SelectionDataSource {
    var values: [String]
    var selectedValue: String?
    var selectionType: SelectionType
}

protocol SelectionTypeViewControllerDelegate: NSObject {
    func selectionTypeViewController(controller: SelectionTypeViewController, type: SelectionType, value: String?)
}

class SelectionTypeViewController: UIViewController {
    
    weak var delegate: SelectionTypeViewControllerDelegate?
    
    var dataSource: SelectionDataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotSelectionValue()
    }
    
    private func addNotSelectionValue() {
        dataSource.values.insert(dataSource.selectionType.notSetTitle, at: 0)
    }
}

extension SelectionTypeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if dataSource.selectionType == .maxPrice && indexPath.row != 0 {
            if let amount = Int64(dataSource.values[indexPath.row]) {
                cell.textLabel?.text = amount.formatted(.currency(code: "USD"))
            }
        } else {
            cell.textLabel?.text = dataSource.values[indexPath.row]
        }
        
        if dataSource.selectedValue == nil && dataSource.values[indexPath.row] == dataSource.selectionType.notSetTitle {
            cell.accessoryType = .checkmark
        } else {
            if dataSource.values[indexPath.row] == dataSource.selectedValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
}

extension SelectionTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 && dataSource.values[indexPath.row] == dataSource.selectionType.notSetTitle {
            dataSource.selectedValue = nil
        } else {
            dataSource.selectedValue = dataSource.values[indexPath.row]
        }
        tableView.reloadData()
        delegate?.selectionTypeViewController(controller: self, type: dataSource.selectionType, value: dataSource.selectedValue)
        dismiss(animated: true)
    }
}
