//
//  WriterViewController.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import UIKit

class WriterViewController: UIViewController {
    
// MARK: - IB Outlets
    @IBOutlet var starButton: UIButton!
    @IBOutlet var headerTextField: UITextField!
    @IBOutlet var mainTextView: UITextView!
    
// MARK: - Public properties
    var status: Bool = false
    var poem: Poem!
    
// MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.layer.cornerRadius = 10
        mainTextView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        mainTextView.layoutManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let poem = poem {
            headerTextField.text = poem.headerPoem
            mainTextView.text = poem.textPoem
            setStatusForStarButton(poem.star)
        }
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let poem = self.poem ?? StorageManager.shared.newPoem()
            poem.headerPoem = headerTextField.text
            poem.textPoem = mainTextView.text
            poem.star = status
            StorageManager.shared.savePoem()
        }
    }
    
// MARK: - IB Actions
    @IBAction func pushedStarButton(_ sender: Any) {
        status.toggle()
        setStatusForStarButton(status)
    }
    
// MARK: - Private methods
    private func setStatusForStarButton(_ color: Bool) {
        starButton.tintColor = color ? .systemYellow : .systemGray2
    }

}

// MARK: - extension: NSLayoutManagerDelegate
extension WriterViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 15
    }
}
