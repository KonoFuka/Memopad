//
//  ExplanationViewController.swift
//  Memopad
//
//  Created by 香野風花 on 2023/06/24.
//

import UIKit

class Explanation {
    var title: String
    var image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
    
    func getImage() -> UIImage {
        return UIImage(named: image)!
    }
}

class ExplanationViewController: UIViewController {
    var textcolor: UIColor!
    var backgroundcolor: UIColor!
    var highlightcolor: UIColor!
    
    @IBOutlet var explanationImage:UIImageView!
    @IBOutlet var explanationTitle:UILabel!
    
    var explanationArray: [Explanation] = [
        Explanation(title: "ホーム画面①", image: "homesetumei.png"),
        Explanation(title: "ホーム画面②", image: "homegamenn.png"),
        Explanation(title: "追加画面", image: "tuika.png")
    ]
    var Index:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        explanationImage.image = explanationArray[Index].getImage()
        explanationTitle.text = explanationArray[Index].title
    }
    
    @IBAction func next() {
        if Index == explanationArray.count - 1 {
            Index = 0
        }else {
            Index += 1
        }
        setUI()
    }
    
    @IBAction func back() {
        if Index == 0 {
            Index = 2
        }else {
            Index -= 1
        }
        setUI()
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
