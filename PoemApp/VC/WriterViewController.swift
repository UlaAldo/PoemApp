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
    @IBOutlet var saveButton: UIBarButtonItem!
    
//    var selectedPoem: Poem!
    
    var poem: Poem!
    
    var delegate: WriterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
//        headerTextField.text = poem?.headerPoem
//        mainTextView.text = poem?.textPoem
        
    }

    @IBAction func saveAction() {
        guard let header = headerTextField.text else { return }
        guard let text = mainTextView.text else { return }
        poem?.textPoem = text
        poem?.headerPoem = header
        
        delegate.savePoem(poem)
        dismiss(animated: true)
        
        }
    
//
//    private func saveAndExit() {
////        guard let header = headerTextField.text else { return }
////        guard let text = mainTextView.text else { return }
//        poem.textPoem = mainTextView.text
//        poem.headerPoem = headerTextField.text
//
//
//        delegate.savePoem(poem)
//        dismiss(animated: true)
//    }
}


    

