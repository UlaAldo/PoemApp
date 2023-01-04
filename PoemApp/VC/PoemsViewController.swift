//
//  PoemsViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit


class PoemsViewController: UIViewController {
    
// MARK: - IB Outlets
    @IBOutlet var poemsTableView: UITableView!
    @IBOutlet var newPoemButton: UIButton!
    
// MARK: - Public properties
    var poems = [Poem](){
        didSet {
            poemsTableView.reloadData()
        }
    }
    
    
// MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        poems = StorageManager.shared.fetchData()
//        po = poems.filter{$0.star == true} + poems.filter{$0.star == false}
        setAppearance()
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
// MARK: - Private methods
    private func setAppearance() {
        poemsTableView.layer.borderWidth = 0.5
        poemsTableView.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    }
}

// MARK: - extension: UITAbleViewDataSource
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

// MARK: - extension: UITableViewDelegate
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
            print("DELETE")
            poems = StorageManager.shared.fetchData()
        }
    }
}

// MARK: - extension: Navigation
extension PoemsViewController: UINavigationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "displayPoem" {
                let indexPath = poemsTableView.indexPathForSelectedRow!
                let poem = poems[indexPath.row]
                let vc = segue.destination as! WriterViewController
                vc.poem = poem
                vc.status = poem.star
            }
        if segue.identifier == "addPoem" {
            let vc = segue.destination as! WriterViewController
            vc.status = false
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        self.poems = StorageManager.shared.fetchData()
    }
}
