//
//  ViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import UIKit

class SynonymViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var cellTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var searchTextField: UITextField!
    
    private var synonyms: [Synonym] = []
    private var rhymes: [String] = []
    
    private var word = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
        searchTextField.addTarget(self,
                                  action: #selector(go),
                                  for: .editingChanged)
        

        }
    
    @objc private func go() {
        word = searchTextField.text ?? ""
        fetchSynonyms()
        fetchRhymes()
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
    func fetchRhymes() {
        NetworkManager.shared.fetchRhymes(with: word) { rhymes in
            self.rhymes = rhymes.components(separatedBy: ", ")
            self.cellTableView.reloadData()
        }
    }

// MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return synonyms.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return synonyms.map{$0.definition}[section]
        default:
            return nil
        }
    }
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        return headerView
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1
        default:
            return rhymes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let syn = synonyms[indexPath.section]
            content.text = syn.synonyms
        default:
            let rhyme = rhymes[indexPath.row]
            content.text = rhyme
        }
        
//        let syn = synonyms[indexPath.section]
//        content.text = syn.synonyms
        
        cell.contentConfiguration = content
        return cell
    }
}
        
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        result.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        var content = cell.defaultContentConfiguration()
//
//        let syn = result[indexPath.row]
//        content.text = syn.synonyms
//
//        cell.contentConfiguration = content
//        return cell
//    }
//


