//
//  SecondViewController.swift
//  名字さん
//
//  Created by 吉永秀和 on 2018/07/02.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import AMJpnMap
import Firebase
import FirebaseFirestore
class SecondViewController: UIViewController {
    @IBOutlet weak var detailView: AMJpnMapDetailView!
    let userDefaults = UserDefaults.standard
    var sDate:String = ""
    var ary:[[String:Any]] = []
    var ary2:[[[String:Any]]] = []
    var himaName:[[(key:String, value: Int)]] = []
    var rank: [Int] = []
    @IBOutlet weak var dayLabel: UILabel!
    var userName:String = ""
    var rankcolor:[UIColor] = []
    var todouhuken = ["北海道","青森県","岩手県","秋田県","宮城県","山形県","福島県",
                      "茨城県","千葉県","栃木県","群馬県","埼玉県","東京都","神奈川県",
                      "新潟県","長野県","山梨県","静岡県","愛知県","三重県","岐阜県",
                      "福井県","石川県","富山県","滋賀県","京都府","兵庫県","奈良県",
                      "和歌山県","大阪府","鳥取県","岡山県","広島県","山口県","島根県",
                      "香川県","徳島県","高知県","愛媛県","福岡県","大分県","宮崎県",
                      "鹿児島県","熊本県","佐賀県","長崎県","沖縄県","海外"]
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = userDefaults.object(forKey: "name") as! String
        let date:Date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM"
        sDate = format.string(from: date)
        format.dateFormat = "yyyy年MM月"
        let tDate = format.string(from: date)
        dayLabel.text = tDate
        let db = Firestore.firestore()
        db.collection("users\(self.sDate)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.ary.append(document.data())
                }
                print(self.ary)
                for i in 0..<self.todouhuken.count {
                    self.ary2.append(self.ary.filter({$0["live"] as! String == self.todouhuken[i]}))
                    self.himaName.append(self.ary2[i].map { ($0["name"] as! String, $0["tapCount"] as! Int) }
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
                        .sorted() { $0.value > $1.value })
//                    print(self.himaName[i].map{ $0.key}.index(of: self.userName))
                    let abc = self.himaName[i].map{ $0.key}.index(of: self.userName)
                    if abc != nil {
                        self.rank.append(self.himaName[i].map{ $0.key}.index(of: self.userName)! + 1)
                    } else {
                        self.rank.append(0)
                    }
//                    print(self.rank[i])
                    if self.rank[i] == 1 {
                        self.rankcolor.append(UIColor.red)
                    } else if self.rank[i] == 2 {
                        self.rankcolor.append(UIColor.yellow)
                    } else if self.rank[i] == 3 {
                        self.rankcolor.append(UIColor.blue)
                    } else if self.rank[i] >= 4 && self.rank[i] <= 5 {
                        self.rankcolor.append(UIColor.orange)
                    } else if self.rank[i] >= 6 && self.rank[i] <= 10 {
                        self.rankcolor.append(UIColor.purple)
                    } else if self.rank[i] >= 11 && self.rank[i] <= 50 {
                        self.rankcolor.append(UIColor.white)
                    } else {
                        self.rankcolor.append(UIColor.green)
                    }
                }
//                print(self.rankcolor)
                self.setcolor()
            }
        }

        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "sky.png")
        bg.layer.zPosition = -1
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

    }
    
    func setcolor() {
        detailView.setFillColor(color: rankcolor[0], prefecture: .hokkaido)
        detailView.setFillColor(color: rankcolor[1], prefecture: .aomori)
        detailView.setFillColor(color: rankcolor[2], prefecture: .iwate)
        detailView.setFillColor(color: rankcolor[3], prefecture: .akita)
        detailView.setFillColor(color: rankcolor[4], prefecture: .miyagi)
        detailView.setFillColor(color: rankcolor[5], prefecture: .yamagata)
        detailView.setFillColor(color: rankcolor[6], prefecture: .fukushima)
        detailView.setFillColor(color: rankcolor[7], prefecture: .ibaraki)
        detailView.setFillColor(color: rankcolor[8], prefecture: .chiba)
        detailView.setFillColor(color: rankcolor[9], prefecture: .tochigi)
        detailView.setFillColor(color: rankcolor[10], prefecture: .gunma)
        detailView.setFillColor(color: rankcolor[11], prefecture: .saitama)
        detailView.setFillColor(color: rankcolor[12], prefecture: .tokyo)
        detailView.setFillColor(color: rankcolor[13], prefecture: .kanagawa)
        detailView.setFillColor(color: rankcolor[14], prefecture: .niigata)
        detailView.setFillColor(color: rankcolor[15], prefecture: .nagano)
        detailView.setFillColor(color: rankcolor[16], prefecture: .yamanashi)
        detailView.setFillColor(color: rankcolor[17], prefecture: .shizuoka)
        detailView.setFillColor(color: rankcolor[18], prefecture: .aichi)
        detailView.setFillColor(color: rankcolor[19], prefecture: .mie)
        detailView.setFillColor(color: rankcolor[20], prefecture: .gifu)
        detailView.setFillColor(color: rankcolor[21], prefecture: .fukui)
        detailView.setFillColor(color: rankcolor[22], prefecture: .ishikawa)
        detailView.setFillColor(color: rankcolor[23], prefecture: .toyama)
        detailView.setFillColor(color: rankcolor[24], prefecture: .shiga)
        detailView.setFillColor(color: rankcolor[25], prefecture: .kyoto)
        detailView.setFillColor(color: rankcolor[26], prefecture: .hyogo)
        detailView.setFillColor(color: rankcolor[27], prefecture: .nara)
        detailView.setFillColor(color: rankcolor[28], prefecture: .wakayama)
        detailView.setFillColor(color: rankcolor[29], prefecture: .osaka)
        detailView.setFillColor(color: rankcolor[30], prefecture: .tottori)
        detailView.setFillColor(color: rankcolor[31], prefecture: .okayama)
        detailView.setFillColor(color: rankcolor[32], prefecture: .hiroshima)
        detailView.setFillColor(color: rankcolor[33], prefecture: .yamaguchi)
        detailView.setFillColor(color: rankcolor[34], prefecture: .shimane)
        detailView.setFillColor(color: rankcolor[35], prefecture: .kagawa)
        detailView.setFillColor(color: rankcolor[36], prefecture: .tokushima)
        detailView.setFillColor(color: rankcolor[37], prefecture: .kochi)
        detailView.setFillColor(color: rankcolor[38], prefecture: .ehime)
        detailView.setFillColor(color: rankcolor[39], prefecture: .fukuoka)
        detailView.setFillColor(color: rankcolor[40], prefecture: .oita)
        detailView.setFillColor(color: rankcolor[41], prefecture: .miyazaki)
        detailView.setFillColor(color: rankcolor[42], prefecture: .kagoshima)
        detailView.setFillColor(color: rankcolor[43], prefecture: .kumamoto)
        detailView.setFillColor(color: rankcolor[44], prefecture: .saga)
        detailView.setFillColor(color: rankcolor[45], prefecture: .nagasaki)
        detailView.setFillColor(color: rankcolor[46], prefecture: .okinawa)
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
