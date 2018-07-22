//
//  PrefViewController.swift
//  名字さん
//
//  Created by 吉永秀和 on 2018/07/19.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit

class PrefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pref:String = ""
    var ranking:[(key:String, value: Int)] = []
    
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var prefLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        print(pref)
        prefLabel.text = pref
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "sky.png")
        bg.layer.zPosition = -1
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        TableView.backgroundColor = .clear
        let date:Date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月"
        let tDate = format.string(from: date)
        dayLabel.text = tDate
        print(ranking)

        // Do any additional setup after loading the view.
    }


    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        // セルに表示する値を設定する
        let rankname = self.ranking.map{ $0.key}
        print(rankname)
        let rankscore = self.ranking.map{ $0.value}
        print(rankscore)
        cell.textLabel!.text = "\(indexPath.row + 1)  \(rankname[indexPath.row])さん"
        cell.detailTextLabel?.text = "\(rankscore[indexPath.row])pt"
        cell.detailTextLabel?.textColor = UIColor.black
        cell.textLabel!.font = UIFont(name: "takumi-yutorifont-P", size: 21)
        cell.detailTextLabel?.font = UIFont(name: "takumi-yutorifont-P", size: 21)
        cell.backgroundColor = .clear
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
