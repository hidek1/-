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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var PickerView: UIPickerView!
    var todouhuken = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                      "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                      "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                      "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                      "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                      "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                      "熊本県","大分県","宮崎県","鹿児島県","沖縄県","海外"]
    var docRef: DocumentReference!
    var ken: String = ""
    let userDefaults = UserDefaults.standard
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func add(_ sender: Any) {
        guard let Text = TextField.text, !Text.isEmpty else { return }
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("users").addDocument(data: [
            "name": Text,
            "live": ken,
            "tapCount": 0,
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

        self.performSegue(withIdentifier: "toSecond", sender: nil)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}

