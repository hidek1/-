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
import AVFoundation

class mainViewController: UIViewController {
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Label4: UILabel!
    @IBOutlet weak var TapButton: UIButton!
    @IBOutlet weak var hukidashi: UIStackView!
    
    @IBOutlet weak var share: UIImageView!
    @IBOutlet weak var coment: UILabel!
    
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
    var sDate:String = ""
    var himaName:[(key:String, value: Int)] = []
    var audioPlayerInstance : AVAudioPlayer! = nil  // 再生するサウンドのインスタンス
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults削除
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        // サウンドファイルのパスを生成
        let soundFilePath = Bundle.main.path(forResource: "ビヨォン", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
        
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "sky.png")
        bg.layer.zPosition = -1
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        self.share.isUserInteractionEnabled = true
        // 画像をタップされたときのアクションを追加
        self.share.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapped(sender:)))
        )
        //現在の日付を取得
        let date:Date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM"
        sDate = format.string(from: date)
        print(sDate)
        TapButton.layer.cornerRadius = TapButton.bounds.width/2
        TapButton.titleLabel?.numberOfLines = 2
        TapButton.setTitle("連続で\nタップする！", for: .normal)
        TapButton.titleLabel?.textAlignment = NSTextAlignment.center
        userName = userDefaults.object(forKey: "name") as! String
        text = userDefaults.object(forKey: "name") as! String
        Label1.text = "読み込み中..."
        Label2.text = "読み込み中..."
        Label4.text = "あなたのスコア 0"
        Label3.text = "読み込み中..."
        if userDefaults.object(forKey: "count") != nil {
            count = userDefaults.object(forKey: "count") as! Int
            Label4.text = "あなたのスコア \(count)"
        }
        self.counter = 0
        let db = Firestore.firestore()
        db.collection("users\(self.sDate)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //                        print("\(document.documentID) => \(document.data())")
                    self.ary.append(document.data())
                }
                self.himaName = self.ary.map { ($0["name"] as! String, $0["tapCount"] as! Int) }
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
                let rank = self.himaName.map{ $0.key}.index(of: self.userName)! + 1
                if rank != 1 {
                    self.morePoint = self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)! - 1].value - self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)!].value
                } else {
                    self.morePoint = 0
                }
                
                self.Label1.text = "\(self.userName)さんは\(rank)番目にひまな名字です"
                self.counter = self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)!].value
                self.Label2.text = "スコア　\(self.counter)"
                self.Label3.text = "次の順位まであと\(self.morePoint)ポイント"
                self.ary.removeAll()
            }
        }

        //timer処理
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.counter = 0
            let db = Firestore.firestore()
            db.collection("users\(self.sDate)").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        self.ary.append(document.data())
                    }
                    self.himaName = self.ary.map { ($0["name"] as! String, $0["tapCount"] as! Int) }
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
                    let rank = self.himaName.map{ $0.key}.index(of: self.userName)! + 1
                    if rank != 1 {
                        self.morePoint = self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)! - 1].value - self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)!].value
                    } else {
                        self.morePoint = 0
                    }
                    
                    self.Label1.text = "\(self.userName)さんは\(rank)番目にひまな名字です"
                    self.counter = self.himaName[self.himaName.map{ $0.key}.index(of: self.userName)!].value
                    self.Label2.text = "スコア　\(self.counter)"
                    self.Label3.text = "次の順位まであと\(self.morePoint)ポイント"
                    self.ary.removeAll()
                }
            }
        })
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.object(forKey: "date") as! String != sDate {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func tapped(sender: UITapGestureRecognizer){
        let rank = self.himaName.map{ $0.key}.index(of: self.userName)! + 1
        let text = "\(self.userName)さんは日本で\(rank)番目にひまな名字です。\n日本一暇な名字を決めるアプリ　名字さん"
        let sampleUrl = NSURL(string: "http://appstore.com/")!
        let items = [text, sampleUrl] as [Any]
        
        // UIActivityViewControllerをインスタンス化
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // UIAcitivityViewControllerを表示
        self.present(activityVc, animated: true, completion: nil)
    }
    @IBAction func tapButton(_ sender: Any) {
        // 連打した時に連続して音がなるようにする
        audioPlayerInstance.currentTime = 0         // 再生位置を先頭(0)に戻してから
        audioPlayerInstance.play()                  // 再生する
        count = count + 1
        Label4.text = "あなたのスコア \(count)"
        userDefaults.set(count, forKey: "count")
        let db = Firestore.firestore()
        db.collection("users\(self.sDate)").document(userDefaults.object(forKey: "ID") as! String).updateData([
            "name": text,
            "live": userDefaults.object(forKey: "live") as! String,
            "tapCount" : count,
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
//                    print("Document updated")
                }
        }
        let date:Date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM"
        sDate = format.string(from: date)
//        print(sDate)
        if userDefaults.object(forKey: "date") as! String != sDate {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        
        if(identifier == "next") {
            let subVC:ThirdViewController = segue.destination as! ThirdViewController
            subVC.himaName = self.himaName
        }
    }
    @IBAction func rankButton(_ sender: Any) {
        if himaName.isEmpty != true {
             performSegue(withIdentifier: "next", sender: nil)
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
