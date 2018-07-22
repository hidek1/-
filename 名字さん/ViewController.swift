//
//  ViewController.swift
//  名字さん
//
//  Created by 吉永秀和 on 2018/06/19.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var PickerView: UIPickerView!
    var todouhuken = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                      "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                      "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                      "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                      "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                      "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                      "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
    var docRef: DocumentReference!
    var ken: String = ""
    let userDefaults = UserDefaults.standard
    var sDate:String = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.center = view.center
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 17.0) // フォントの設定をする.
        textView.textColor = .black // フォントの色の設定をする.
        textView.textAlignment = .center
        textView.dataDetectorTypes = .all // リンク、日付などを自動的に検出してリンクに変換する.
        textView.isEditable = false // テキストを編集不可にする.
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedString = NSMutableAttributedString(string: "プライパシーポリシーはこちら")
        
        attributedString.addAttributes([.foregroundColor: UIColor.black, .paragraphStyle: style, .font: UIFont.systemFont(ofSize: 17.0)], range: NSMakeRange(0, attributedString.length))
        
        let range = attributedString.mutableString.range(of: "こちら")
        attributedString.setAttributes([.underlineStyle : NSUnderlineStyle.styleSingle.rawValue, .link: URL(string: "https://hidekazuyoshi.hatenablog.com/")!, .foregroundColor: UIColor.black, .paragraphStyle: style,], range: range)
        
        textView.attributedText = attributedString
        
        
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "sky.png")
        bg.layer.zPosition = -1
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        TextField.delegate = self
        //現在の日付を取得
        let date:Date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM"
        sDate = format.string(from: date)
        print(sDate)
        PickerView.delegate = self
        PickerView.dataSource = self
        ken = todouhuken[0]
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool)  {
        if userDefaults.object(forKey: "count") != nil {
            self.performSegue(withIdentifier: "toSecond", sender: nil)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return todouhuken.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return todouhuken[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ken = todouhuken[row]
        
    }

    func textFieldShouldReturn(_ TextField: UITextField) -> Bool{
        // キーボードを閉じる
        TextField.resignFirstResponder()
        return true
    }

    @IBAction func add(_ sender: Any) {
        guard let Text = TextField.text, !Text.isEmpty else { return }
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("users\(self.sDate)").addDocument(data: [
            "name": Text,
            "live": ken,
            "tapCount" : 0,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        userDefaults.set(Text, forKey: "name")
        userDefaults.set(ken, forKey: "live")
        userDefaults.set(ref!.documentID, forKey: "ID")
        userDefaults.set(sDate, forKey: "date")
//        userDefaults.set("1", forKey: "date")

        self.performSegue(withIdentifier: "toSecond", sender: nil)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}
private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        #if swift(>=4.0)
        text = String(prospectiveText[..<maxCharIndex])
        #else
        text = prospectiveText.substring(to: maxCharIndex)
        #endif
        
        selectedTextRange = selection
    }
    
}

