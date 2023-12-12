//
//  MemoViewController.swift
//  Memopad
//
//  Created by 香野風花 on 2022/10/22.
//

import UIKit

class MemoViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet var level:UISegmentedControl!
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var titles: [String] = []
    var contents: [String] = []
    var deadline: [String] = []
    
    var stars: [String] = []
    var star = "0"
    
    var checkButton: [String] = []
    
    var textcolor: UIColor!
    var backgroundcolor: UIColor!
    var highlightcolor: UIColor!
    
    @IBOutlet var maintitle: UILabel!
    @IBOutlet var explanation: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var important: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //色の設定
        maintitle.textColor = textcolor
        explanation.textColor = textcolor
        date.textColor = textcolor
        important.textColor = textcolor
        view.backgroundColor = backgroundcolor
        
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
        saveData.register(defaults: ["titles": [], "contents":[], "deadline":[], "checkButton":[] ])
        
        titles = saveData.object(forKey: "titles") as! [String]
        contents = saveData.object(forKey: "contents") as! [String]
        deadline = saveData.object(forKey: "deadline") as! [String]
        
        checkButton = saveData.object(forKey: "checkButton") as! [String]
        if saveData.object(forKey: "stars") != nil {
        stars = saveData.object(forKey: "stars") as! [String]
        }
        
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
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
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        star = String(sender.selectedSegmentIndex)
    }

    @IBAction func saveMemo() {
        let title = titleTextField.text!
        let content = contentTextView.text!
        let date = dateField.text!
        
        titles.append(title)
        contents.append(content)
        deadline.append(date)
        stars.append(star)
        checkButton.append("◯")
        
        saveData.set(titles, forKey: "titles")
        saveData.set(contents, forKey: "contents")
        saveData.set(deadline, forKey: "deadline")
        saveData.set(stars, forKey: "stars")
        saveData.set(checkButton, forKey: "checkButton")
        
        print("タイトル",titles)
        print("説明",contents)
        print("日付",deadline)
        print("スター",stars)
        print("チェック",checkButton)
        
        let alert: UIAlertController = UIAlertController(title:"保存", message: "todoの追加を保存しました", preferredStyle: .alert)
        
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
