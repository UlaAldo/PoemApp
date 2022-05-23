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
    
    private var poems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        poems = StorageManager.shared.fetchPoems()
    
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let writerVC = segue.destination as! WriterViewController
//        writerVC.poems = poems
//
//    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let writerVC = segue.source as? WriterViewController else { return }
        guard let header = writerVC.headerTextField.text else { return }
        guard let textPoem = writerVC.mainTextView.text else { return }
        let poem = Poem(header: header, textPoem: textPoem)
        poems.append(poem.header)
        StorageManager.shared.save(poem: poem.header)
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
        content.text = poem
        cell.contentConfiguration = content
        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension PoemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let poem = poems[indexPath.row]
        performSegue(withIdentifier: "details", sender: poem)
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
//        guard let indexPath = tableView.indexPathForSelectedRow else { return }
//        let track = trackList[indexPath.row]
        writerVC.poems = sender as? Poem
}

}
