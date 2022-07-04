//
//  ViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import UIKit

class SynonymViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cellTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    private var synonyms: [Synonym] = []
    
    private var word = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellTableView.delegate = self
        cellTableView.dataSource = self
        searchTextField.delegate = self
        cellTableView.layer.cornerRadius = 10
        cellTableView.isHidden = true

        }
    
    @IBAction func showButton(_ sender: Any) {
        word = searchTextField.text ?? ""
        fetchSynonyms()
        cellTableView.isHidden = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.resignFirstResponder()
    
        return true
    }
    

    func fetchSynonyms() {
        NetworkManager.shared.fetchSynonym(with: word) { synonyms in
            self.synonyms = synonyms
            self.cellTableView.reloadData()
    }
}
}

// MARK: TableView
    
extension SynonymViewController: UITableViewDataSource, UITableViewDelegate {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        synonyms.count
    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       synonyms[section].definition.firstUppercased
       
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            50
//        }
   
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = .systemGray2
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        header.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        header.textLabel?.lineBreakMode = .byWordWrapping
        header.textLabel?.numberOfLines = 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let syn = synonyms[indexPath.section]
        content.text = syn.synonyms.capitalized
        
        cell.contentConfiguration = content
        return cell
    }

    }


extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
}
