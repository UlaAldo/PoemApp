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
    @IBOutlet var colorsCollection: UICollectionView!
    
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    // MARK: - Public properties
    var status: Bool!
    var poem: Poem!
    var centerCell: ColorCell!
    var colors: [UIColor] = []
    
    // MARK: - Private properties
    private let one = UIColor(named: "one")!
    private let two = UIColor(named: "two")!
    private let three = UIColor(named: "three")!
    private let four = UIColor(named: "four")!
    private let five = UIColor(named: "five")!
    private let six = UIColor(named: "six")!
    private let seven = UIColor(named: "seven")!
    private let eight = UIColor(named: "eight")!
    private let nine = UIColor(named: "nine")!
    private let ten = UIColor(named: "ten")!
    private let eleven = UIColor(named: "1")!
    
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesignView()
        setCollectionView()
        colors = [one, two, three, four, five, six, seven, eight, nine, ten, eleven]
        self.tabBarController?.tabBar.isHidden = true
        
//        mainTextView.scrollRangeToVisible(NSRange(..<mainTextView.text.endIndex, in: mainTextView.text))

        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLastPoem()
        registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let poem = self.poem ?? StorageManager.shared.newPoem()
            if headerTextField.text != "" || mainTextView.text != "" {
                poem.headerPoem = headerTextField.text
                poem.textPoem = mainTextView.text
                poem.star = status
                poem.date = Date().format()
                
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
    
    
    @IBAction func deletedPoem(_ sender: Any) {
        let deletedAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this poem?", preferredStyle: UIAlertController.Style.alert)
        
        deletedAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            StorageManager.shared.delete(self.poem)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel")
        }))
        
        present(deletedAlert, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func setStatusForStarButton(_ color: Bool) {
        starButton.tintColor = color ? UIColor(named: "Orange") : .white
    }
    
    private func setLastPoem() {
        if let poem = poem {
            headerTextField.text = poem.headerPoem
            mainTextView.text = poem.textPoem
            setStatusForStarButton(poem.star)
        }
    }
    
    private func setDesignView() {
        mainTextView.layer.cornerRadius = 10
//        mainTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        mainTextView.layoutManager.delegate = self
        headerTextField.delegate = self
        mainTextView.delegate = self
        headerTextField.tintColor = UIColor(named: "DarkGreen")
        mainTextView.tintColor = UIColor(named: "DarkGreen")
        
    }
    
    private func setCurrentDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy   HH:mm"
        let dateString = df.string(from: date)
        
        return dateString
    }
    

     
    
    // MARK: - Collection View Settings
    private func setCollectionView() {
        colorsCollection.collectionViewLayout = layout()
        colorsCollection.showsHorizontalScrollIndicator = false
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(40),
            heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitem: item, count: 1)
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: nil, top: .flexible(0),
            trailing: nil, bottom: .flexible(0))
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(
            section: section, configuration:config)
        return layout
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let layoutMargins: CGFloat = self.colorsCollection.layoutMargins.left + self.colorsCollection.layoutMargins.right
        let sideInset = (self.view.frame.width / 2) - layoutMargins
        self.colorsCollection.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        let centerPoint = CGPoint(x: self.colorsCollection.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.colorsCollection.frame.size.height / 2 + scrollView.contentOffset.y)
        
        if let indexPath = self.colorsCollection.indexPathForItem(at: centerPoint), self.centerCell == nil {
            self.centerCell = (self.colorsCollection.cellForItem(at: indexPath) as! ColorCell)
            self.centerCell?.transformToLarge()
        }
        
        if let cell = self.centerCell {
            let offsetX = centerPoint.x - cell.center.x
            if offsetX < -20 || offsetX > 20 {
                cell.transformToStandard()
                self.centerCell = nil
            }
        }
    }
}



// MARK: - UICollectionViewDataSource
extension WriterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = colors[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell

        cell.layer.cornerRadius = cell.frame.size.width/2
        cell.backgroundColor = color
        return cell
    }
    
   
}

// MARK: - UICollectionViewDelegate
extension WriterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.item]
        mainTextView.backgroundColor = color
        headerTextField.backgroundColor = color
        
        colorsCollection.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)

    }
}

// MARK: - extension: NSLayoutManagerDelegate
extension WriterViewController: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        15
    }
}

// MARK: - UITextFieldDelegate
extension WriterViewController: UITextFieldDelegate, UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.action(sender:)))
        
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.action(sender:)))
        
        return true
    }
    
    @objc func action(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem? = deleteButton
    }
   
    
    
    // MARK: - Keyboard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        mainTextView.contentInset = insets
        mainTextView.scrollIndicatorInsets = insets

 
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        mainTextView.contentInset = UIEdgeInsets.zero
        mainTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    

    
   

}

