//
//  PoemsViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit


class PoemsViewController: UIViewController {
    
    @IBOutlet var poemsTableView: UITableView!
    @IBOutlet var newPoemButton: UIButton!
    
    var poems = [Poem]() {
        didSet {
        poemsTableView.reloadData()
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poems = StorageManager.shared.fetchData()
        poemsTableView.layer.cornerRadius = 10
        
    
    }
}
// MARK: - UITAbleViewDataSource
extension PoemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        poems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poemsTableView.dequeueReusableCell(withIdentifier: "show", for: indexPath) as! PoemCell
        let poem = poems[indexPath.row]
        cell.configure(with: poem)

        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension PoemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let poem = poems[indexPath.row]
        
        if editingStyle == .delete {
            StorageManager.shared.delete(poem)
            poems = StorageManager.shared.fetchData()
        }
    }
}

// MARK: - Navigation
extension PoemsViewController: UINavigationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayPoem" {
                let indexPath = poemsTableView.indexPathForSelectedRow!
                let poem = poems[indexPath.row]
                let displayNoteViewController = segue.destination as! WriterViewController
                displayNoteViewController.poem = poem
            }
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        self.poems = StorageManager.shared.fetchData()
    }
}
