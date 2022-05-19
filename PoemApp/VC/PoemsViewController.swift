//
//  PoemsViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit

protocol WriterViewControllerDelegate {
    func savePoem(_ contact: String)
}

class PoemsViewController: UIViewController {
    

    @IBOutlet var poemsTableView: UITableView!
    @IBOutlet var newPoemButton: UIButton!
    
    
    private var poems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        poems = StorageManager.shared.fetchPoems()
    
    }
    

}
// MARK: - UITAbleViewDataSource
extension PoemsViewController: UITableViewDataSource {
    

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    poems.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
}

}
// MARK: - UITableViewDelegate
extension PoemsViewController: UITableViewDelegate {
    
}

// MARK: - NewContactViewControllerDelegate
extension PoemsViewController: WriterViewControllerDelegate {
    func savePoem(_ poem: String) {
        poems.append(poem)
        poemsTableView.reloadData()
    }
}
