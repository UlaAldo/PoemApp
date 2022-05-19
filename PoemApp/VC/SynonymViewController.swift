//
//  ViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import UIKit

class SynonymViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var cellTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    private var synonyms: [Synonym] = []
    private var rhymes: [String] = []
    
    
//    lazy var one = rhymes.first?.rhymes.components(separatedBy: ", ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cellTableView.isHidden = true
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            fetchSynonyms()
//        default:
//            fetchRhymes()
//        }
        }
    
//    override func viewWillLayoutSubviews() {
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            fetchSynonyms()
//        default:
//            fetchRhymes()
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
//        cellTableView.isHidden = false
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchSynonyms()
        default:
            fetchRhymes()
        }
    }

    func fetchSynonyms() {
        NetworkManager.shared.fetchSynonym { synonyms in
            self.synonyms = synonyms
            self.cellTableView.reloadData()
    }
}
    func fetchRhymes() {
        NetworkManager.shared.fetchRhymes { rhymes in
            self.rhymes = rhymes.rhymes.components(separatedBy: ", ")
            self.cellTableView.reloadData()
        }
    }
//    let new = result.map{$0.synonyms.components(separatedBy: ", ")}

        
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return synonyms.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return synonyms.map{$0.definition}[section]
        default:
            return ""
        }
       
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


