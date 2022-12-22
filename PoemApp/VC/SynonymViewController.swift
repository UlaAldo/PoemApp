//
//  ViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import UIKit

class SynonymViewController: UIViewController {
    
// MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
// MARK: - Private properties
    private var synonyms: [Synonym] = []
    private var word = ""
    
// MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.isHidden = true

    }
    
// MARK: - IB Actions
    @IBAction func showButton(_ sender: Any) {
        self.view.endEditing(true)
        showSynonym()
    }
    
// MARK: - Private methods
    private func showSynonym() {
        let alert = UIAlertController()
        word = searchTextField.text ?? ""
        if word.isEmpty {
            alert.showAlert(fromController: self)
        } else {
            tableView.isHidden = false
            fetchSynonyms()
        }
    }
    
    private func fetchSynonyms() {
        spinner.isHidden = false
        spinner.startAnimating()
        NetworkManager.shared.fetchSynonym(word) { result in
            switch result {
            case .success(let synonyms):
                self.synonyms = synonyms
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - extension: UITextFieldDelegate
extension SynonymViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            synonyms = []
            tableView.isHidden = true
            
        }
        return true
    }
    
}


// MARK: - extension: UITAbleViewDataSource

extension SynonymViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        synonyms.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        synonyms[section].definition.firstUppercased
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let syn = synonyms[indexPath.section]
        content.text = syn.synonyms.firstUppercased
        
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - extension: UITableViewDelegate

extension SynonymViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = .systemGray2
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        header.textLabel?.lineBreakMode = .byWordWrapping
        header.textLabel?.numberOfLines = 3
        
    }
    
  
}

// MARK: - extension: StringProtocol

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    
}
