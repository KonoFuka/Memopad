//
//  SettingViewController.swift
//  Memopad
//
//  Created by 香野風花 on 2023/01/24.
//

import UIKit

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate, UITabBarDelegate {
    
    var saveData: UserDefaults = UserDefaults.standard
    
    @IBOutlet var textLabel:UILabel!
    @IBOutlet var backgroundLabel: UILabel!
    @IBOutlet var highlightLabel: UILabel!
    
    @IBOutlet var textColor: UIButton!
    @IBOutlet var backgroundColor: UIButton!
    @IBOutlet var highlightColor: UIButton!
    
    
    
    var color: UIColor!
    
    var color1: UIColor! = UIColor.black
    var saveColor1: UserDefaults = UserDefaults.standard
    
    var color2: UIColor! = UIColor.white
    var saveColor2: UserDefaults = UserDefaults.standard
    
    var color3: UIColor! = UIColor.red
    var saveColor3: UserDefaults = UserDefaults.standard
    
    var colornumber: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //保存した色の取り出し
        if UserDefaults.standard.data(forKey: "color1") != nil {
        let colorData1: Data = UserDefaults.standard.data(forKey: "color1")!
            let color1: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData1)!
            print("取り出し",color1)
            
            textLabel.textColor = color1
            textColor.tintColor = color1
            
            self.tabBarController?.tabBar.unselectedItemTintColor = color1
        }
        
        if UserDefaults.standard.data(forKey: "color2") != nil {
        let colorData2: Data = UserDefaults.standard.data(forKey: "color2")!
            let color2: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData2)!
            
            print(color2)
            backgroundColor.tintColor = color2
            backgroundLabel.textColor = color2
            view.backgroundColor = color2
            
            self.tabBarController?.tabBar.backgroundColor = color2
        }

        if UserDefaults.standard.data(forKey: "color3") != nil {
        let colorData3: Data = UserDefaults.standard.data(forKey: "color3")!
            let color3: UIColor = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData3)!
            
            print(color3)
            
            highlightLabel.textColor = color3
            highlightColor.tintColor = color3
            
            self.tabBarController?.tabBar.tintColor = color3
        }
        
        
//        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 60))
//        textLabel.font = UIFont.boldSystemFont(ofSize: 50)
//        textLabel.makeOutLine(strokeWidth: -2.0, oulineColor: .white, foregroundColor: .blue)

    }
    
    override func viewWillAppear(_ animated: Bool) {
          
    }
    
    var colorPicker: UIColorPickerViewController!
    
    func showColorPicker(){
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor.black // 初期カラー
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
        color = UIColor.black
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // 色を選択したときの処理
        print("選択した色:" ,(viewController.selectedColor))
        color = (viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // カラーピッカーを閉じたときの処理
        self.viewDidLoad()
        if colornumber == 1 {
            textLabel.textColor = color
            
            textColor.tintColor = color
            backgroundColor.tintColor = color
            highlightColor.tintColor = color
            
            color1 = color
            let colorData1 : Data = try! NSKeyedArchiver.archivedData(withRootObject: color1, requiringSecureCoding: UIColor.supportsSecureCoding)
            saveData.set(colorData1, forKey: "color1")
            
        }else if colornumber == 2{
            backgroundLabel.textColor = color
//            backgroundColor.tintColor = color
            
            color2 = color
            let colorData2 : Data = try! NSKeyedArchiver.archivedData(withRootObject: color2, requiringSecureCoding: UIColor.supportsSecureCoding)
            saveData.set(colorData2, forKey: "color2")
            
        }else if colornumber == 3 {
            highlightLabel.textColor = color
//            highlightColor.tintColor = color
            
            color3 = color
            let colorData3 : Data = try! NSKeyedArchiver.archivedData(withRootObject: color3, requiringSecureCoding: UIColor.supportsSecureCoding)
            saveData.set(colorData3, forKey: "color3")
        }

        self.viewDidLoad()
    }
    
    @IBAction func textcolor() {
        showColorPicker()
        colornumber = 1
        
    }
    
    @IBAction func backgroundcolor() {
        showColorPicker()
        colornumber = 2
    }
    
    @IBAction func highlightcolor() {
        showColorPicker()
        colornumber = 3
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
