//
//  RhymesViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 29/06/22.
//

import UIKit

class RhymesViewController: UIViewController {
    
// MARK: - IB Outlets
    @IBOutlet var showButton: UIButton!
    @IBOutlet var rhymesTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
// MARK: - Private properties
    private var rhymes: [String] = []
    private var word = ""
    
// MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        rhymesTextField.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.isHidden = true
    }
    
// MARK: - IB Actions
    @IBAction func showButton(_ sender: Any) {
       showRhymes()
    }
    
// MARK: - Private methods
    private func showRhymes() {
        let alert = UIAlertController()
        word = rhymesTextField.text ?? ""
        if word.isEmpty {
            alert.showAlert(fromController: self)
        } else {
            tableView.isHidden = false
            fetchRhymes()
        }
    }

    private func fetchRhymes() {
        NetworkManager.shared.fetchRhymes(with: word) { rhymes in
            self.rhymes = rhymes.components(separatedBy: ", ").map{$0.capitalized}
            self.tableView.reloadData()
        }
    }
}

// MARK: - extension: UITextFieldDelegate
    extension RhymesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            rhymesTextField.resignFirstResponder()
    
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == rhymesTextField {
            rhymes = []
            tableView.reloadData()
        }
        return true
    }
}
    
    // MARK: - extension: UITAbleViewDataSource, UITableViewDelegate
    extension RhymesViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rhymes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showRhymes", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let rhyme = rhymes[indexPath.row]
        content.text = rhyme
        cell.contentConfiguration = content
        
        return cell
    }

}

