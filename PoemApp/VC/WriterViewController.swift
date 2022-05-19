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
    

}
