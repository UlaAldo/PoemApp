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
    @IBOutlet var startLabel: UILabel!
    
    @IBOutlet var popUpButton: UIButton!
    
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
        setAppearance()
        setNavBar()
//        po = poems.filter{$0.star == true} + poems.filter{$0.star == false}

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        poems = StorageManager.shared.fetchData()
        popUpButton.tintColor = UIColor(named: "DarkGreen")
        setMenuFilter()
        setStartLabel()
    }
    
// MARK: - Filter methods
    
    private func setMenuFilter() {
        let menuClosure = {(action: UIAction) in
                self.update(number: action.title)
            }
        
            popUpButton.menu = UIMenu(children: [
                UIAction(title: "no filter", state: .on, handler:
                                        menuClosure),
                UIAction(title: "star poems" ,state: .off, handler: menuClosure),
                    UIAction(title: "option 3",state: .off, handler: menuClosure),
                ])
            popUpButton.showsMenuAsPrimaryAction = true
        
        
    }
    
   private func update(number:String) {
        if number == "no filter" {
            popUpButton.tintColor = UIColor(named: "DarkGreen")
            poems = StorageManager.shared.fetchData()
        }
        if number == "star poems" {
            poems = poems.filter{$0.star == true}
            popUpButton.tintColor = UIColor(named: "Orange")
//            popUpButton.layer.borderColor = UIColor(named: "Orange")?.cgColor
//            popUpButton.layer.borderWidth = 1
            
        }
        if number == "option 3" {
            poems = poems.sorted(by: {$0.date! < $1.date!})
        }
    }
    
    
// MARK: - Private methods
    private func setNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setAppearance() {
        poemsTableView.layer.borderWidth = 0.5
        poemsTableView.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    }
    
    private func setStartLabel() {
        if poems.isEmpty {
            startLabel.isHidden = false
            startLabel.animate(newText: "This is the place for your inspiration", characterDelay: 0.1)
            popUpButton.isHidden = true
        } else {
            startLabel.isHidden = true
            popUpButton.isHidden = false
        }
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
            poems = StorageManager.shared.fetchData()
            setStartLabel()
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
                vc.deleteButton.tintColor = .white
                
            }
        if segue.identifier == "addPoem" {
            let vc = segue.destination as! WriterViewController
            vc.status = false
            vc.deleteButton.tintColor = UIColor(named: "DarkGreen")
            vc.deleteButton.isEnabled = false
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        self.poems = StorageManager.shared.fetchData()
    }
}




