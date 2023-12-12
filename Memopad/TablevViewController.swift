import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, UIPopoverPresentationControllerDelegate{
    var Edit:Int!


    var leftButtonItem: UIBarButtonItem!
    var sortButtonItem: UIBarButtonItem!
    var rightButtonItem: UIBarButtonItem!
    var today:Date!
    var day:Date!

    var CHECK:Int!

    var checkButton: [String] = []
    var stars: [String] = []

    var textcolor: UIColor!
    var backgroundcolor: UIColor!
    var highlightcolor: UIColor!

    var saveData: UserDefaults = UserDefaults.standard

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        cell?.backgroundColor = backgroundcolor
        tableView.backgroundColor = backgroundcolor
        
        print(checkButton.count,titles.count )

        if checkButton.count < titles.count {
            while checkButton.count < titles.count {
                checkButton += ["◯"]
              }
            
        }else if checkButton.count > titles.count {
            while checkButton.count > titles.count {
            checkButton.remove(at:0)
            }
        }
        
        saveData.set(checkButton, forKey: "checkButton")

        if stars.count < titles.count {
            while stars.count < titles.count {
                stars += ["0"]
                print("加える",stars)
              }
            saveData.set(stars, forKey: "stars")
        }

        let title = cell?.viewWithTag(1) as! UILabel
        title.text = titles[indexPath.item]
        let text = cell?.viewWithTag(2) as! UILabel
        text.text = contents[indexPath.item]
        let date = cell?.viewWithTag(3) as! UILabel
        date.text = deadline[indexPath.item]

        let check = cell?.viewWithTag(4) as! UILabel
        check.text = checkButton[indexPath.item]

        //期限
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"

        day = formatter.date(from: deadline[indexPath.item])

//        print(color1, color2, color3)

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
                date.textColor = highlightcolor
                }
                else{
                date.textColor = textcolor
                }
            }
            title.textColor = textcolor
            text.textColor = textcolor
            check.textColor = textcolor
            if stars[indexPath.row] == "1"{
                check.textColor = highlightcolor
            }
        }


        return cell!
    }

    let readPassword: Bool = true

   @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //バーボタンの設定
        //左上のボタン
        leftButtonItem = UIBarButtonItem(title: "edit", style: .done, target: self, action: #selector(leftButtonPressed(_:)))
        sortButtonItem = UIBarButtonItem(title: "sort", style: .done, target: self, action: #selector(sortButtonPressed(_:)))
        
        //右上のボタン
//        dropDownButton = PullDownButton(type: .system)
//        dropDownButton.setTitle("sort", for: .normal)
//        dropDownButton.dropdownMenu = createDropdownMenu()
        
//        let dropdownBarButtonItem = UIBarButtonItem(customView: dropDownButton)
//        navigationItem.leftBarButtonItem = dropdownBarButtonItem
        Edit = 0
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem, sortButtonItem]
        
//        settingDropdownButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        //保存した色の取り出し
        if UserDefaults.standard.data(forKey: "color1") != nil {
            let colorData1: Data = UserDefaults.standard.data(forKey: "color1")!
            print (colorData1)
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

        if UserDefaults.standard.data(forKey: "color3") != nil {
        let colorData3: Data = UserDefaults.standard.data(forKey: "color3")!
        let color3: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData3)!
        print("highlight",color3)
        highlightcolor = color3
        }else{
            highlightcolor = UIColor.red
        }
        
        view.backgroundColor = backgroundcolor
        
        self.navigationController?.navigationBar.tintColor = textcolor
        self.navigationController?.navigationBar.backgroundColor = backgroundcolor
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
                .foregroundColor:textcolor
            ]
        
        //タブバーの色
        self.tabBarController?.tabBar.backgroundColor = backgroundcolor
        self.tabBarController?.tabBar.unselectedItemTintColor = textcolor
        self.tabBarController?.tabBar.tintColor = highlightcolor

        saveData.register(defaults: ["titles": [], "contents": [], "deadline": [], "checkButton": [], "stars":[] ])
        
        //　データの読み込み
        titles = saveData.object(forKey: "titles") as! [String]
        contents = saveData.object(forKey: "contents") as! [String]
        deadline = saveData.object(forKey: "deadline") as! [String]
        checkButton = saveData.object(forKey: "checkButton") as! [String]
        if saveData.object(forKey: "stars") != nil {
        stars = saveData.object(forKey: "stars") as! [String]
        }
        
        print("タイトル", titles, "説明", contents, "期限", deadline,"チェック",checkButton, "タグ",stars)

//        print(checkButton)

        table.dataSource = self
        table.delegate = self

        table.rowHeight = 75
        
        self.table.backgroundColor = nil;

        _ = UICollectionLayoutListConfiguration(appearance: .plain)
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    // ポップオーバーの表示元のビューを格納する変数

    @objc func sortButtonPressed(_ sender: UIBarButtonItem) {
        print("ボタンが押された")
        
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "並び替えますか？", preferredStyle:  UIAlertController.Style.alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "期限順", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("1")
            self.dateActionTapped()
        })

        let defaultAction2: UIAlertAction = UIAlertAction(title: "重要度順", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("2")
            self.customActionTapped()
        })

        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addAction(defaultAction2)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    //期限順
    func dateActionTapped() {
        if self.titles.count <= 1 {
            print ("一つもしくは空です")
            
        }else{
            var newTitle: [String] = []
            var newText: [String] = []
            var newDate: [String] = []
            var newCheck: [String] = []
            var newStar: [String] = []
            
            var NoLimitTitle: [String] = []
            var NoLimitText: [String] = []
            var NoLimitDate: [String] = []
            var NoLimitCheck: [String] = []
            var NoLimitStar:[String] = []
                
                for i in 0 ..< titles.count{
                    print("カウント",i)

                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd hh:mm"
                    day = formatter.date(from: deadline[i])
                    
                    if day != nil { //期限が設定されているtodo
                        newDate.append(deadline[i])
                        newTitle.append(titles[i])
                        newText.append(contents[i])
                        newCheck.append(checkButton[i])
                        newStar.append(stars[i])
                        print("期限順の並び替え")
                        
                    }else{ //期限が設定されてないtodo
                        NoLimitDate.append(deadline[i])
                        NoLimitTitle.append(titles[i])
                        NoLimitText.append(contents[i])
                        NoLimitCheck.append(checkButton[i])
                        NoLimitStar.append(stars[i])
                        print("期限なし")
                    }
                }
            print("並び替え前",newDate,newTitle,newText,newCheck,newStar)

            let index = newDate.indices.sorted { newDate[$0] < newDate[$1] }
            newTitle = index.map { newTitle[$0] }
            newText = index.map { newText[$0] }
            newCheck = index.map { newCheck[$0] }
            newStar = index.map { newStar[$0] }
            newDate = index.map { newDate[$0] }
            
            print("並び替え後",newDate,newTitle,newText,newStar)
            
            saveData.set(newTitle + NoLimitTitle, forKey: "titles")
            saveData.set(newText + NoLimitText, forKey: "contents")
            saveData.set(newDate + NoLimitDate, forKey: "deadline")
            saveData.set(newCheck + NoLimitCheck, forKey: "checkButton")
            saveData.set(newStar + NoLimitStar, forKey: "stars")
            
            viewWillAppear(true)
            print("期限順")
        }
    }
    
    //重要度順
    func customActionTapped() {
        let index = self.stars.indices.sorted { stars[$0] > stars[$1] }
        print("並び替え前",titles,contents,checkButton,stars,deadline)
        
        titles = index.map { titles[$0] }
        contents = index.map { contents[$0] }
        checkButton = index.map { checkButton[$0] }
        stars = index.map { stars[$0] }
        deadline = index.map { deadline[$0] }
        
        print("並び替え後",titles,contents,checkButton,stars,deadline)
        
        saveData.set(titles, forKey: "titles")
        saveData.set(contents, forKey: "contents")
        saveData.set(deadline, forKey: "deadline")
        saveData.set(stars, forKey: "stars")
        saveData.set(checkButton, forKey: "checkButton")
        
        viewWillAppear(true)
        
        print("重要度順")
    }

    //編集ボタン
    @objc func leftButtonPressed(_ sender: UIBarButtonItem) {
        if Edit == 0 {
            table.isEditing = true
            Edit = 1
            sender.title = "done"
        }
        else{
            table.isEditing = false
            Edit = 0
            sender.title = "edit"
        }
    }

    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")

//        saveData.register( defaults: [ "checkbutton": [] ] )

//        checkButton = saveData.object(forKey: "checkbutton") as! [String]
        print("\(indexPath.row)")

        print("\(checkButton[indexPath.row])")

        if checkButton[indexPath.row] == "◯" {
            print("チェック")
            checkButton[indexPath.row] = "●"
            
            titles.append(titles[indexPath.row])
            titles.remove(at: indexPath.row)
            contents.append(contents[indexPath.row])
            contents.remove(at: indexPath.row)
            deadline.append(deadline[indexPath.row])
            deadline.remove(at: indexPath.row)
            stars.append(stars[indexPath.row])
            stars.remove(at: indexPath.row)
            checkButton.append(checkButton[indexPath.row])
            checkButton.remove(at: indexPath.row)

            print("\(checkButton[indexPath.row])")
            table.reloadData()

        }else{
            print("チェックを外す")

            checkButton[indexPath.row] = "◯"
            
            titles.insert(titles[indexPath.row], at: 0)
            titles.remove(at: indexPath.row + 1)
            contents.insert(contents[indexPath.row], at: 0)
            contents.remove(at: indexPath.row + 1)
            deadline.insert(deadline[indexPath.row], at: 0)
            deadline.remove(at: indexPath.row + 1)
            stars.insert(stars[indexPath.row], at: 0)
            stars.remove(at: indexPath.row + 1)
            checkButton.insert(checkButton[indexPath.row], at: 0)
            checkButton.remove(at: indexPath.row + 1)


            print("\(checkButton[indexPath.row])")
            table.reloadData()
        }
        print ("チェック",checkButton)
        
        saveData.set(titles, forKey: "titles")
        saveData.set(contents, forKey: "contents")
        saveData.set(deadline, forKey: "deadline")
        saveData.set(checkButton, forKey: "checkButton")
        saveData.set(stars, forKey: "stars")
        }


    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
        }

    var Movetitle:String!
    var Movetext:String!
    var Movedate:String!
    var Movestar:String!

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        Movetitle = titles[sourceIndexPath.row]
        Movetext = contents[sourceIndexPath.row]
        Movedate = deadline[sourceIndexPath.row]
        Movestar = stars[sourceIndexPath.row]

        print("ビフォー",titles.count)

        self.titles.remove(at: sourceIndexPath.row)
        self.contents.remove(at: sourceIndexPath.row)
        self.deadline.remove(at: sourceIndexPath.row)
        self.stars.remove(at: sourceIndexPath.row)

        print("アフター",titles.count)

        titles.insert(Movetitle, at: destinationIndexPath.row)
        contents.insert(Movetext, at: destinationIndexPath.row)
        deadline.insert(Movedate, at: destinationIndexPath.row)
        stars.insert(Movestar, at: destinationIndexPath.row)
        
        saveData.set(titles, forKey: "titles")
        saveData.set(contents, forKey: "contents")
        saveData.set(deadline, forKey: "deadline")
        saveData.set(checkButton, forKey: "checkButton")
        saveData.set(stars, forKey: "stars")
        }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    var titles: [String] = []
    var contents: [String] = []
    var deadline: [String] = []
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [self] (action, view, completionHandler) in
            //削除処理を記述
            self.titles.remove(at: indexPath.row)
            self.contents.remove(at: indexPath.row)
            self.deadline.remove(at: indexPath.row)
            self.checkButton.remove(at: indexPath.row)
            self.stars.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)

            saveData.set(titles, forKey: "titles")
            saveData.set(contents, forKey: "contents")
            saveData.set(deadline, forKey: "deadline")
            saveData.set(checkButton, forKey: "checkButton")
            saveData.set(stars, forKey: "stars")

            // 実行結果に関わらず記述
            completionHandler(true)

            print("削除")
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


////並び替えボタンの設定②
//class PullDownButton: UIButton {
//    var dropdownMenu: UIAlertController?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addTarget(self, action: #selector(showMenu), for: .touchUpInside)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        addTarget(self, action: #selector(showMenu), for: .touchUpInside)
//    }
//
//    @objc func showMenu() {
//        guard let dropdownMenu = dropdownMenu, let viewController = window?.rootViewController else {
//            return
//        }
//        dropdownMenu.popoverPresentationController?.sourceView = self
//        dropdownMenu.popoverPresentationController?.sourceRect = bounds
//        dropdownMenu.popoverPresentationController?.permittedArrowDirections = .down
//        viewController.present(dropdownMenu, animated: true, completion: nil)
//    }
//
//
//}
