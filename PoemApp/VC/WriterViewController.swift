//
//  WriterViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit

class WriterViewController: UIViewController {

    @IBOutlet var starButton: UIButton!
    @IBOutlet var headerTextField: UITextField!
    @IBOutlet var mainTextView: UITextView!
   
    var delegate: WriterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        savedPoem()
    }
    
    private func savedPoem() {
        guard let header = headerTextField.text else { return }
        guard let textPoem = mainTextView.text else { return }
        let poem = Poem(header: header, textPoem: textPoem)
        StorageManager.shared.save(poem: poem.header)
        
        delegate.savePoem(poem.header)
        dismiss(animated: true)
    }

}
