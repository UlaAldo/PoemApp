//
//  RhymesViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 29/06/22.
//

import UIKit

class RhymesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
   
    

    @IBOutlet var showButton: UIButton!
    @IBOutlet var rhymesTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    private var rhymes: [String] = []
    
    private var word = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        rhymesTextField.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.isHidden = true
    }
    
    @IBAction func showButton(_ sender: Any) {
        tableView.isHidden = false
        word = rhymesTextField.text ?? ""
        fetchRhymes()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            rhymesTextField.resignFirstResponder()
    
        return true
    }
    
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
    
    func fetchRhymes() {
        NetworkManager.shared.fetchRhymes(with: word) { rhymes in
            self.rhymes = rhymes.components(separatedBy: ", ").map{$0.capitalized}
            self.tableView.reloadData()
        }
    }
    
}
