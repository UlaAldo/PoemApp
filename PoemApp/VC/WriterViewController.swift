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
    @IBOutlet var colorsCollection: UICollectionView!
    
    
    // MARK: - Public properties
    var status: Bool!
    var poem: Poem!
    var centerCell: ColorCell!
    var colors: [UIColor] = []
    
    let one = UIColor(red: 240, green: 232, blue: 205, alpha: 1)
    let two = UIColor(red: 0.969, green: 1, blue: 0, alpha: 1)
    let three = UIColor(red: 1, green: 0.294, blue: 0.122, alpha: 1)
    let four = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let five = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let six = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let seven = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let eight = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let nine = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    let ten = UIColor(red: 0.122, green: 0.867, blue: 1, alpha: 1)
    
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setToolbar()
        setCollectionView()
        colors = [one, two, three, four, five, six, seven, eight, nine, ten]
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLastPoem()
        let layoutMargins: CGFloat = self.colorsCollection.layoutMargins.left + self.colorsCollection.layoutMargins.right
        let sideInset = (self.view.frame.width / 2) - layoutMargins
        self.colorsCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: sideInset)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let poem = self.poem ?? StorageManager.shared.newPoem()
            if headerTextField.text != "" || mainTextView.text != "" {
                poem.headerPoem = headerTextField.text
                poem.textPoem = mainTextView.text
                poem.star = status
                poem.date = setCurrentDate()
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
            if offsetX < -15 || offsetX > 15 {
                cell.transformToStandard()
                self.centerCell = nil
            }
        }
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
        done.tintColor = UIColor(named: "Orange")
        mainTextView.inputAccessoryView = toolbar
        headerTextField.inputAccessoryView = toolbar
    }
    
    @objc private func done() {
        self.view.endEditing(true)
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
        
        colorsCollection.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
    }
}



