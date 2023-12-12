import UIKit

class EditViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet var level:UISegmentedControl!
    
    var saveButtonItem: UIBarButtonItem!
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var number:Int!
    
    var titles: [String] = []
    var contents: [String] = []
    var deadline: [String] = []
    
    var stars: [String] = []
    
    var star: String!
    
    var textcolor: UIColor!
    var backgroundcolor: UIColor!
    var highlightcolor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "todoの編集"
        
        print("Edit画面だよ")
        
        saveButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(editButtonPressed(_:)))
        
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            toolbar.setItems([spacelItem, doneItem], animated: true)
        
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        
        //
        saveData.register(defaults: ["titles":[], "contents":[], "deadline":[], "stars":[] ])
        
        titles = saveData.object(forKey: "titles") as! [String]
        contents = saveData.object(forKey: "contents") as! [String]
        deadline = saveData.object(forKey: "deadline") as! [String]
        stars = saveData.object(forKey: "stars") as! [String]
        
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
        
        titleTextField.text =  titles[number]
        contentTextView.text = contents[number]
        dateField.text = deadline[number]
        level.selectedSegmentIndex = Int(stars[number])!
        
        star = (stars[number])
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
    }
    
    @objc func done() {
        dateField.endEditing(true)
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        dateField.text = "\(formatter.string(from: datePicker.date))"}

    @objc func editButtonPressed(_ sender: UIBarButtonItem) {
        let title = titleTextField.text!
        let content = contentTextView.text!
        let date = dateField.text!
        let level = String(star)
         
        titles[number] = (title)
        contents[number] = (content)
        deadline[number] = (date)
        stars[number] = (level)
        
        saveData.set(titles, forKey: "titles")
        saveData.set(contents, forKey: "contents")
        saveData.set(deadline, forKey: "deadline")
        saveData.set(stars, forKey: "stars")
        
        print("タイトル",titles)
        print("説明",contents)
        print("日付",deadline)
        print("重要度",stars)
        
        let alert: UIAlertController = UIAlertController(title:"保存", message: "todoの変更を保存しました", preferredStyle: .alert)
        
        alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    }
            )
        )
        present(alert, animated: true, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
//        self.present(vc, animated: true)
//        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        star = String(sender.selectedSegmentIndex)
    }
    
}

