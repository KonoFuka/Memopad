//
//  MemoCollectionViewController.swift
//  Memopad
//
//  Created by 香野風花 on 2022/11/05.
//

import UIKit

class MemoCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveData.register(defaults: ["titles": [], "contents": [], "deadline": [] ])
        
        titles = saveData.object(forKey: "titles") as! [String]
        contents = saveData.object(forKey: "contents") as! [String]
        deadline = saveData.object(forKey: "deadline") as! [String]
        
        collectionview.dataSource = self
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        collectionview.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionview.reloadData()
        
        super.viewWillAppear(animated)
        collectionview.reloadData()
        print("viewWillAppear()")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let title = cell.contentView.viewWithTag(1) as! UILabel
        title.text = titles[indexPath.item]
        
        let text = cell.contentView.viewWithTag(2) as! UILabel
        text.text = contents[indexPath.item]
        
        let date = cell.contentView.viewWithTag(3) as! UILabel
        date.text = deadline[indexPath.item]
        
        //var contentConfiguration = UIListContentConfiguration.cell()
        
        //contentConfiguration.text = titles[indexPath.item]
        //contentConfiguration.secondaryText = contents[indexPath.item]
        //contentConfiguration.text = deadline[indexPath.item]
        
        //cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    
    @IBOutlet var collectionview: UICollectionView!
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var titles: [String] = []
    var contents: [String] = []
    var deadline: [String] = []
    

    
   
}
