//
//  ImportamtViewController.swift
//  Memopad
//
//  Created by 香野風花 on 2023/02/25.
//

import UIKit

class ImportamtViewController: UIViewController, UITableViewDataSource{
    
    var lightButtonItem: UIBarButtonItem!
    var today:Date!
    var day:Date!
    
    var CHECK:Int!
    
    var checkButton: [String] = []
    
    var newTitle: [String] = []
    var newText: [String] = []
    var newDate: [String] = []
    var newStar: [String] = []
    
    var NoLimitTitle: [String] = []
    var NoLimitText: [String] = []
    var NoLimitDate: [String] = []
    var NoLimitStar: [String] = []
    
    var textcolor: UIColor!
    var backgroundcolor: UIColor!
    var highlightcolor: UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaa")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if checkButton.count < newTitle.count {
            while checkButton.count < newTitle.count {
                checkButton += ["◯"]
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let title = cell?.viewWithTag(1) as! UILabel
        title.text = newTitle[indexPath.item]
        let text = cell?.viewWithTag(2) as! UILabel
        text.text = newText[indexPath.item]
        let date = cell?.viewWithTag(3) as! UILabel
        date.text = newDate[indexPath.item]
        
        let check = cell?.viewWithTag(4) as! UILabel
        check.text = checkButton[indexPath.item]
        
        //期限
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        day = formatter.date(from: newDate[indexPath.item])
        
        cell?.backgroundColor = backgroundcolor
        tableView.backgroundColor = backgroundcolor
        
        if checkButton[indexPath.row] == "●" {
            title.textColor = UIColor.gray
            date.textColor = UIColor.gray
            text.textColor = UIColor.gray
            check.textColor = UIColor.gray
            
        }else{
            if day == nil {
                date.textColor = textcolor
            }
            else{
                today = Date()
                if day.compare(today) == .orderedAscending {
                    //                    print("期限超過",day as Any)
                    date.textColor = highlightcolor
                }
                else{
                    date.textColor = textcolor
                }
            }
            
            title.textColor = textcolor
            text.textColor = textcolor
            //            date.textColor = textcolor
            check.textColor = textcolor
        }
        
        
        return cell!
    }
    
    let readPassword: Bool = true
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = lightButtonItem
        
        Edit = 0
        // ユーザデフォルトリセット
        //        let appDomain = Bundle.main.bundleIdentifier
        //        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        //tableView.tableViewLayout = UITableViewCompositionalLayout.list(using: configuration)
        //tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveData.register(defaults: ["titles": [], "contents": [], "deadline": [], "checkButton": [], "stars": [] ])
        
        if UserDefaults.standard.data(forKey: "color1") != nil {
            let colorData1: Data = UserDefaults.standard.data(forKey: "color1")!
            let color1: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData1)!
            print("text",color1)
            textcolor = color1
        }else{
            textcolor = UIColor.black
        }
        
        if UserDefaults.standard.data(forKey: "color2") != nil {
            let colorData2: Data = UserDefaults.standard.data(forKey: "color2")!
            let color2: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData2)!
            print("background",color2)
            backgroundcolor = color2
        }else{
            backgroundcolor = UIColor.white
        }
        
        view.backgroundColor = backgroundcolor
        self.navigationController?.navigationBar.tintColor = textcolor
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor:textcolor
        ]
        
        if UserDefaults.standard.data(forKey: "color3") != nil {
            let colorData3: Data = UserDefaults.standard.data(forKey: "color3")!
            let color3: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData3)!
            print("highlight",color3)
            highlightcolor = color3
        }else{
            highlightcolor = UIColor.red
        }
        
        
        
        titles = saveData.object(forKey: "titles") as! [String]
        contents = saveData.object(forKey: "contents") as! [String]
        deadline = saveData.object(forKey: "deadline") as! [String]
        stars = saveData.object(forKey: "stars") as! [String]
        checkButton = saveData.object(forKey: "checkButton") as! [String]
        
        newTitle.removeAll()
        newText.removeAll()
        newDate.removeAll()
        
        NoLimitTitle.removeAll()
        NoLimitText.removeAll()
        NoLimitDate.removeAll()
        
        print(titles.count)
        print("内容",titles, contents, deadline)
        print("個数",titles.count, contents.count, deadline.count)
        
        for i in 0 ..< titles.count{
            print("カウント",i)
            today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd hh:mm"
            star = stars[i]
            
            if stars == 1 {
                newTitle.append(titles[i])
                newText.append(contents[i])
                newDate.append(deadline[i])
                newStar.append(stars[i])
                print(newTitle,newText, newDate,newStar)
            }else{
                NoLimitTitle.append(titles[i])
                NoLimitText.append(contents[i])
                NoLimitDate.append(deadline[i])
                NoLimitStar.append(stars[i])
                //                print(NoLimitDate, NoLimitText, NoLimitDate)
            }
        }
        
        
        
        //        print("TableView WillAppear")
        
        table.dataSource = self
        table.delegate = self
        
        table.rowHeight = 75
        
        _ = UICollectionLayoutListConfiguration(appearance: .plain)
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        
        //        saveData.register( defaults: [ "checkbutton": [] ] )
        //
        //        checkButton = saveData.object(forKey: "checkbutton") as! [String]
        //h
        print("\(indexPath.row)")
        
        print("\(checkButton[indexPath.row])")
        
        if checkButton[indexPath.row] == "◯" {
            print("チェック")
            checkButton[indexPath.row] = "●"
            
            print("\(checkButton[indexPath.row])")
            table.reloadData()
            
            
        }else{
            print("チェックを外す")
            
            checkButton[indexPath.row] = "◯"
            
            print("\(checkButton[indexPath.row])")
            table.reloadData()
        }
        print ("チェック",checkButton)
        
    }
    
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTitle.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var Movetitle:String!
    var Movetext:String!
    var Movedate:String!
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        Movetitle = newTitle[sourceIndexPath.row]
        Movetext = newText[sourceIndexPath.row]
        Movedate = newDate[sourceIndexPath.row]
        
        //        print("ビフォー",newTitle.count)
        
        self.newTitle.remove(at: sourceIndexPath.row)
        //        print(titles.count)
        self.newText.remove(at: sourceIndexPath.row)
        self.newDate.remove(at: sourceIndexPath.row)
        
        //        print("アフター",newTitle.count)
        
        
        print(sourceIndexPath.row)
        print(destinationIndexPath.row)
        
        newTitle.insert(Movetitle, at: destinationIndexPath.row)
        newText.insert(Movetext, at: destinationIndexPath.row)
        newDate.insert(Movedate, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    var Edit:Int!
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var titles: [String] = []
    var contents: [String] = []
    var deadline: [String] = []
    
}

extension DateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [self] (action, view, completionHandler) in
            
            print("削除", newTitle[indexPath.row], newText[indexPath.row], newDate[indexPath.row])
            //削除処理を記述
            
            self.newTitle.remove(at: indexPath.row)
            self.newText.remove(at: indexPath.row)
            self.newDate.remove(at: indexPath.row)
            self.checkButton.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            print("新しいタイトル", newDate + NoLimitDate)
            saveData.set(newTitle + NoLimitTitle, forKey: "titles")
            saveData.set(newText + NoLimitText, forKey: "contents")
            saveData.set(newDate + NoLimitDate, forKey: "deadline")
            saveData.set(checkButton, forKey: "checkButton")
            
            print("新しいタイトル", titles, "新しい説明", contents, "新しい期限", deadline)
            
            // 実行結果に関わらず記述
            completionHandler(true)
            
            //            print("削除")
            print(titles, contents, deadline)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "編集") { [self] (action, view, completionHandler) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            vc.number = (indexPath.row)
            
            print("編集")
        }
        
        editAction.backgroundColor = UIColor.gray
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
    }

}
