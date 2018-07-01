//
//  mainViewController.swift
//  名字さん
//
//  Created by 吉永秀和 on 2018/06/28.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class mainViewController: UIViewController {
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
   
    let userDefaults = UserDefaults.standard
    var counter = 0
    var count = 0
    var text : String = ""
    var ary:[[String:Any]] = []
    var userName:String = ""
    var morePoint:Int = 0
    var timer = Timer()
    //processing count
    var counting = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //UserDefaults削除
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        userName = userDefaults.object(forKey: "name") as! String
        text = userDefaults.object(forKey: "name") as! String
        Label1.text = "\(userName)さんは日本で（読み込み中）番目にひまな名字です"
        Label2.text = "読み込み中..."
        Label3.text = "次の順位まであと（読み込み中）ポイント"
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
////                        print("\(document.documentID) => \(document.data())")
//                        self.counter += document.data()["tapCount"] as! Int
//                        self.Label2.text = "スコア　\(self.counter)"
//                        self.ary.append(document.data())
//                    }
//                    print(self.ary)
//                    print("登録者数=\(self.ary.count)")
//                    print("合計カウント=\(self.ary.map{ $0["tapCount"] as! Int}.reduce(0){$0 + $1})")
//                    let himaName = self.ary.map { ($0["name"] as! String, $0["tapCount"] as! Int) }
//                        .reduce([String:Int]()) { (result, info) in
//                            var newResult = result
//                            switch result[info.0] {
//                            case .some:
//                                newResult[info.0] = info.1 + result[info.0]!
//                            default:
//                                newResult[info.0] = info.1
//                            }
//                            return newResult
//                        }
//                        .sorted() { $0.value > $1.value }
//                    print("暇な苗字=\(himaName)")
//                    print(himaName[himaName.map{ $0.key}.index(of: self.userName)! - 1].value - himaName[himaName.map{ $0.key}.index(of: self.userName)!].value)
//                    self.morePoint = himaName[himaName.map{ $0.key}.index(of: self.userName)! - 1].value - himaName[himaName.map{ $0.key}.index(of: self.userName)!].value
//
//                    self.Label1.text = "\(self.userName)さんは日本で\(himaName.map{ $0.key}.index(of: self.userName)! + 1)番目にひまな名字です"
//                    self.Label3.text = "次の順位まであと\(self.morePoint)ポイント"
//                }
//        }
        if userDefaults.object(forKey: "count") != nil {
            count = userDefaults.object(forKey: "count") as! Int
            print(count)
        }
        
        
        //timer処理
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.counter = 0
            let db = Firestore.firestore()
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        self.counter += document.data()["tapCount"] as! Int
                        self.Label2.text = "スコア　\(self.counter)"
                        self.ary.append(document.data())
                    }
                    let himaName = self.ary.map { ($0["name"] as! String, $0["tapCount"] as! Int) }
                        .reduce([String:Int]()) { (result, info) in
                            var newResult = result
                            switch result[info.0] {
                            case .some:
                                newResult[info.0] = info.1 + result[info.0]!
                            default:
                                newResult[info.0] = info.1
                            }
                            return newResult
                        }
                        .sorted() { $0.value > $1.value }
                    print("暇な苗字=\(himaName)")
                    print(himaName[himaName.map{ $0.key}.index(of: self.userName)! - 1].value - himaName[himaName.map{ $0.key}.index(of: self.userName)!].value)
                    self.morePoint = himaName[himaName.map{ $0.key}.index(of: self.userName)! - 1].value - himaName[himaName.map{ $0.key}.index(of: self.userName)!].value
                    
                    self.Label1.text = "\(self.userName)さんは日本で\(himaName.map{ $0.key}.index(of: self.userName)! + 1)番目にひまな名字です"
                    self.Label3.text = "次の順位まであと\(self.morePoint)ポイント"
                }
            }
        })
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapButton(_ sender: Any) {
        counter = counter + 1
        count = count + 1
        Label2.text = "スコア　\(counter)"
        userDefaults.set(count, forKey: "count")
        let db = Firestore.firestore()
        db.collection("users").document(userDefaults.object(forKey: "ID") as! String).updateData([
            "name": text,
            "live": userDefaults.object(forKey: "live") as! String,
            "tapCount": count,
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
//                    print("Document updated")
                }
        }
        if morePoint > 1 {
            morePoint = morePoint - 1
            self.Label3.text = "次の順位まであと\(self.morePoint)ポイント"
        } else {

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
