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
   
    var poems: Poem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        headerTextField.text = poems.header
//        mainTextView.text = poems.textPoem
        
    }
    



}
