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
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private properties
    private var rhymes: [String] = []
    private var word = ""
    private let alert = UIAlertController()
    
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        rhymesTextField.delegate = self
        tableView.isHidden = true
    }
    
    
    // MARK: - IB Actions
    @IBAction func showButton(_ sender: Any) {
        showRhymes()
        self.view.endEditing(true)
    }
    
    
    // MARK: - Private methods
    private func showRhymes() {
        let alert = UIAlertController()
        word = rhymesTextField.text ?? ""
        if word.isEmpty {
            alert.showAlert(from: self, "Empty input", "Please, write the word")
        } else {
            fetchRhymes()
        }
    }
    
    private func fetchRhymes() {
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.shared.fetchRhymes(self.word) { result in
                switch result {
                case .success(let rhymes):
                    self.rhymes = rhymes.components(separatedBy: ", ").map{$0.capitalized}
                    
                case .failure(let error):
                    print(error)
                }
                DispatchQueue.main.async {
                    self.showResult()
                    
                }
            }
        }
    }
    
    private func showResult() {
        spinner.stopAnimating()
        if rhymes.isEmpty {
            alert.showAlert(from: self, "Sorry", "Please, try another word")
        } else {
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}


// MARK: - extension: UITextFieldDelegate
extension RhymesViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rhymesTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == rhymesTextField {
            rhymes = []
            tableView.isHidden = true
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

