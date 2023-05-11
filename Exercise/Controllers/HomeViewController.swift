//
//  ViewController.swift
//  Exercise
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchVehicleTypeButton: UIButton!
    @IBOutlet weak var searchDealButton: UIButton!
    
    @IBAction func searchVehicleTypeAction(_ sender: Any) {
        goToVehicleTypeScreen()
    }
    
    @IBAction func searchDealsOfTheDayAction(_ sender: Any) {
        searchTextField.resignFirstResponder()
        let inputText = searchTextField.text ?? ""
        let allVehicles = DataSet.shared.vehicleData()
        let searchInputTextResult = DataSet.shared.searchMakeOrModel(text: inputText, vehicles: allVehicles)
        printSearchInputTextResult(vehicles: searchInputTextResult)
        goToSearchScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Private function
    private func configView() {
        searchTextField.roundCornerWithHeight(borderColor: UIColor.white)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTextField.frame.size.height))
        leftView.backgroundColor = searchTextField.backgroundColor
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.delegate = self
        
        searchVehicleTypeButton.roundCornerWithHeight()
        searchDealButton.roundCornerWithHeight()
    }
    
    private func printSearchInputTextResult(vehicles: [Vehicle]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(vehicles)
            print(data.jsonString())
        } catch {
            print(error)
        }
    }
    
    private func goToVehicleTypeScreen() {
        guard let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleTypeViewController") as? VehicleTypeViewController else {
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func goToSearchScreen() {
        guard let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.roundCornerWithHeight()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.roundCornerWithHeight(borderColor: UIColor.white)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

