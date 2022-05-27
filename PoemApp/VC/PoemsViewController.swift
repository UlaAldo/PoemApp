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
    
    private var poems: [Poem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        poems = StorageManager.shared.fetchPoems()
    
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let writerVC = segue.source as? WriterViewController else { return }
        guard let header = writerVC.headerTextField.text else { return }
        guard let textPoem = writerVC.mainTextView.text else { return }
        let poem = Poem(header: header, textPoem: textPoem)
        poems.append(poem)
        StorageManager.shared.save(poem: poem)
        poemsTableView.reloadData()
    }

}
// MARK: - UITAbleViewDataSource
extension PoemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        poems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poemsTableView.dequeueReusableCell(withIdentifier: "poem", for: indexPath)
        let poem = poems[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = poem.header
        content.secondaryText = poem.textPoem
        cell.contentConfiguration = content
        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension PoemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let poem = poems[indexPath.row]
//        guard let vc = storyboard?.instantiateViewController(identifier: "show") as? WriterViewController else {
//            return
//        }
//        vc.poems = poem
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            StorageManager.shared.deletePoem(at: indexPath.row)
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
// MARK: - Navigation
extension PoemsViewController: UINavigationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writerVC = segue.destination as? WriterViewController else { return }
        guard let indexPath = poemsTableView.indexPathForSelectedRow else { return }
        let poem = poems[indexPath.row]
        writerVC.poems = poem
        
    }
    
}
