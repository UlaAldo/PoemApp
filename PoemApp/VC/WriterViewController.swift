//
//  WriterViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit

class WriterViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet var starButton: UIButton!
    @IBOutlet var headerTextField: UITextField!
    @IBOutlet var mainTextView: UITextView!
    
    // MARK: - Public properties
    var status: Bool!
    var poem: Poem!
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLastPoem()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let poem = self.poem ?? StorageManager.shared.newPoem()
            if headerTextField.text != "" || mainTextView.text != "" {
                poem.headerPoem = headerTextField.text
                poem.textPoem = mainTextView.text
                poem.star = status
                StorageManager.shared.savePoem()
            } else {
                StorageManager.shared.delete(poem)
            }
        }
    }
    
    // MARK: - IB Actions
    @IBAction func pushedStarButton(_ sender: Any) {
        status.toggle()
        setStatusForStarButton(status)
    }
    
    // MARK: - Private methods
    private func setStatusForStarButton(_ color: Bool) {
        starButton.tintColor = color ? UIColor(named: "Orange") : .systemGray3
    }
    
    private func setLastPoem() {
        if let poem = poem {
            headerTextField.text = poem.headerPoem
            mainTextView.text = poem.textPoem
            setStatusForStarButton(poem.star)
        }
    }
    
    private func setDesign() {
        mainTextView.layer.cornerRadius = 10
        mainTextView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        mainTextView.layoutManager.delegate = self
        headerTextField.delegate = self
        mainTextView.delegate = self
        headerTextField.tintColor = UIColor(named: "DarkGreen")
        mainTextView.tintColor = UIColor(named: "DarkGreen")
    }
}

// MARK: - extension: NSLayoutManagerDelegate
extension WriterViewController: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        15
    }
}

// MARK: - UITextFieldDelegate
extension WriterViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func setToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            done
        ]
        done.tintColor = UIColor(named: "DarkGreen")
        mainTextView.inputAccessoryView = toolbar
        headerTextField.inputAccessoryView = toolbar
    }
    
    @objc private func done() {
        self.view.endEditing(true)
    }
}
