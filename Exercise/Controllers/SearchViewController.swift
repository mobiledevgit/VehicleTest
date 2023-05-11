//
//  SearchViewController.swift
//  Exercise
//

import UIKit

struct SearchCondition {
    var make: String?
    var model: String?
    var year: Int?
    var maxPrice: Int64?
}

class SearchViewController: UIViewController {
    static let maxPrices = [2000, 4000, 6000, 8000, 10000, 15000, 20000, 25000, 30000,
                            35000, 40000, 45000, 50000, 60000, 70000, 80000, 90000, 100000,
                            125000, 150000, 175000]
    
    // MARK: @IBOutlet

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var resultTableView: UITableView!
    
    // MARK: Properties
    var condition = SearchCondition()
    
    var searchVehicles = [(String, [Vehicle])]()
    var searchResultTotal: SearchResult?
    
    // MARK: @IBAction
    @IBAction func makeSelectAction(_ sender: Any) {
        showMakeSelect()
    }
    
    @IBAction func modelSelectAction(_ sender: Any) {
        showModelSelect()
    }
    
    @IBAction func yearSelectAction(_ sender: Any) {
        showYearSelect()
    }
    
    @IBAction func priceSelectAction(_ sender: Any) {
        showPriceSelect()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchWithConditions()
    }
    
    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Private functions
    private func configView() {
        navigationItem.title = "Search Vehicle"
        
        stackView.layer.cornerRadius = 4
        stackView.layer.masksToBounds = true
        stackView.layer.cornerCurve = .continuous
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray2.cgColor
        
        searchButton.roundCornerWithHeight()
        
        resultTableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
        resultTableView.register(UINib(nibName: "SearchResultHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchResultHeaderView")
    }
    
    private func showMakeSelect() {
        let makes = DataSet.shared.getMakeTypes()
        showSelectionScreen(values: makes, type: .make, selectedValue: condition.make)
    }
    
    private func showModelSelect() {
        let models = DataSet.shared.getModels(with: condition.make)
        showSelectionScreen(values: models, type: .model, selectedValue: condition.make)
    }

    private func showYearSelect() {
        let years = DataSet.shared.getYear(with: condition.model).map { String($0) }
        var selectedValue: String? = nil
        if let year = condition.year {
            selectedValue = String(year)
        }
        showSelectionScreen(values: years, type: .year, selectedValue: selectedValue)
    }

    private func showPriceSelect() {
        let maxPrices = SearchViewController.maxPrices.map { String($0) }
        var selectedValue: String? = nil
        if let maxPrice = condition.maxPrice {
            selectedValue = String(maxPrice)
        }
        showSelectionScreen(values: maxPrices, type: .maxPrice, selectedValue: selectedValue)

    }

    private func showSelectionScreen(values: [String], type: SelectionType, selectedValue: String?) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionTypeViewController") as? SelectionTypeViewController else {
            return
        }
        controller.dataSource = SelectionDataSource(values: values, selectedValue: selectedValue, selectionType: type)
        controller.delegate = self
        present(controller, animated: true)
    }
    
    private func updateConditionValue() {
        if let make = condition.make {
            makeLabel.text = make
        } else {
            makeLabel.text = "All makes"
        }

        if let model = condition.model {
            modelLabel.text = model
        } else {
            modelLabel.text = "All models"
        }
        
        if let year = condition.year {
            yearLabel.text = String(year)
        } else {
            yearLabel.text = "Any"
        }
        
        if let maxPrice = condition.maxPrice {
            maxPriceLabel.text = String(maxPrice)
        } else {
            maxPriceLabel.text = "No max price"
        }
    }
    
    private func searchWithConditions() {
        let vehicles = DataSet.shared.searchVehicle(make: condition.make,
                                                        model: condition.model,
                                                        year: condition.year,
                                                        maxPrice: condition.maxPrice)
        let groupingDictionary = Dictionary(grouping: vehicles) { "\($0.make) \($0.model)" }
        searchVehicles = groupingDictionary.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 })

        searchResultTotal = DataSet.shared.getSearchResultTotal(vehicles: vehicles)
        resultTableView.reloadData()
    }    
}

// MARK: SelectionTypeViewControllerDelegate
extension SearchViewController: SelectionTypeViewControllerDelegate {
    func selectionTypeViewController(controller: SelectionTypeViewController, type: SelectionType, value: String?) {
        switch type {
        case .make:
            if condition.make != value {
                condition.model = nil
                condition.year = nil
            }
            condition.make = value
        case .model:
            condition.model = value
        case .year:
            if let year = value {
                condition.year = Int(year)
            } else {
                condition.year = nil
            }
        case .maxPrice:
            if let maxPrice = value {
                condition.maxPrice = Int64(maxPrice)
            } else {
                condition.maxPrice = nil
            }
        }
        updateConditionValue()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var section = 0
        if !searchVehicles.isEmpty {
            section = 2
        } else if searchResultTotal != nil {
            section = 1
        }
        return section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return searchVehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell?.configCell(name: "Lowest Price", value: String(searchResultTotal?.minPrice ?? 0))
            case 1:
                cell?.configCell(name: "Median Price", value: String(searchResultTotal?.medianPrice ?? 0))
            case 2:
                cell?.configCell(name: "Highest Price", value: String(searchResultTotal?.maxPrice ?? 0))
            default:
                break
            }
        } else {
            cell?.configCell(name: searchVehicles[indexPath.row].0,
                             value: String(searchVehicles[indexPath.row].1.count))
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor.white
        } else {
            cell?.backgroundColor = UIColor.systemGray6
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                            withIdentifier: "SearchResultHeaderView")
                            as? SearchResultHeaderView
        else {
            return nil
        }
        if section == 0 {
            view.configView(title: "Total Vehicles Matched", value: String(searchResultTotal?.vehicleCount ?? 0))
        } else {
            view.configView(title: "Matches by Make and Model", value: nil)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
