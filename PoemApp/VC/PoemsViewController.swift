//
//  PoemsViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit

protocol WriterViewControllerDelegate {
    func savePoem(_ contact: Poem)
}

class PoemsViewController: UIViewController {
    
    @IBOutlet var poemsTableView: UITableView!
    @IBOutlet var newPoemButton: UIButton!
    
    var poems: [Poem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let writerVC = segue.destination as! WriterViewController
        writerVC.delegate = self
        
    }

    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let poems):
                self.poems = poems
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
// MARK: - UITAbleViewDataSource
extension PoemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        poems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poemsTableView.dequeueReusableCell(withIdentifier: "show", for: indexPath)
        let poem = poems[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = poem.headerPoem
        content.secondaryText = poem.textPoem
        cell.contentConfiguration = content
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
            poems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 8
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x,
                                 y: cell.bounds.origin.y,
                                 width: cell.bounds.width,
                                 height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}

extension PoemsViewController: WriterViewControllerDelegate {
    func savePoem(_ poem: Poem) {
        poems.append(poem)
        poemsTableView.reloadData()
    }
}


// MARK: - Navigation
//extension PoemsViewController: UINavigationControllerDelegate {
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let writerVC = segue.destination as? WriterViewController else { return }
//        guard let indexPath = poemsTableView.indexPathForSelectedRow else { return }
//        let poem = poems[indexPath.row]
//        writerVC.selectedPoem = poem
//        writerVC.poem = { [weak self] poem in
//            self?.poems.append(poem)
//
//        }
//    }
//
//}

