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
    private let alert = UIAlertController()
    var splitSynonyms: [String] = []
    
// MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        tableView.isHidden = true

       
    }
    
// MARK: - IB Actions
    @IBAction func showButton(_ sender: Any) {
        self.view.endEditing(true)
        showSynonym()
    }
    
// MARK: - Private methods
    private func showSynonym() {
        word = searchTextField.text ?? ""
        if word.isEmpty {
            alert.showAlert(from: self, "Empty input", "Please, write the word")
        } else {
            fetchSynonyms()

        }
    }
    
    
    private func fetchSynonyms() {
        spinner.isHidden = false
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.shared.fetchSynonym(self.word) { result in
                switch result {
                case .success(let synonyms):
                    self.synonyms = synonyms
                    self.getSplitSynonyms()
                case .failure(let error):
                    print(error)
                    
                }
                DispatchQueue.main.async {
                    self.showResult()
                }
            }
        }
    }
    
    private func getSplitSynonyms() {
        let synonyms = synonyms.map{$0.synonyms.components(separatedBy: [",", " "]).filter({!$0.isEmpty})}
        let unique = synonyms.flatMap{$0}
        splitSynonyms = Array(Set(unique))
    }
    
    private func showResult() {
        spinner.stopAnimating()
        if synonyms.isEmpty {
            alert.showAlert(from: self, "Sorry", "Please, try another word")
        } else {
            tableView.isHidden = false
            tableView.reloadData()
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
        showSynonym()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        splitSynonyms.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let syn = splitSynonyms[indexPath.row]
        content.text = syn.firstUppercased
        
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

//extension Array where Element: Equatable {
//    var unique: [Element] {
//        var uniqueValues: [Element] = []
//        forEach { item in
//            guard !uniqueValues.contains(item) else { return }
//            uniqueValues.append(item)
//        }
//        return uniqueValues
//    }
//}
