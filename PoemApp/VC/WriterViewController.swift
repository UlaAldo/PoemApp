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
    
    var status: Bool = false
    
    var poem: Poem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let poem = poem {
            headerTextField.text = poem.headerPoem
            mainTextView.text = poem.textPoem
            setStatusForStarButton(poem.star)
        }
    }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "save" {
                let poem = self.poem ?? StorageManager.shared.newPoem()
                poem.headerPoem = headerTextField.text
                poem.textPoem = mainTextView.text
                poem.star = status
                StorageManager.shared.savePoem()
            }
        }
        
    
    @IBAction func pushedStarButton(_ sender: Any) {
        status.toggle()
        setStatusForStarButton(status)
    }
    
    private func setStatusForStarButton(_ color: Bool) {
        starButton.tintColor = color ? .systemYellow : .systemGray3
    }

}







    

