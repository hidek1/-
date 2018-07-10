//
//  ThirdViewController.swift
//  名字さん
//
//  Created by 吉永秀和 on 2018/07/04.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    
    var himaName:[(key:String, value: Int)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "sky.png")
        bg.layer.zPosition = -1
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        TableView.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return himaName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SampleCell")
        
        // セルに表示する値を設定する
        let rankname = self.himaName.map{ $0.key}
        let rankscore = self.himaName.map{ $0.value}
        cell.textLabel!.text = "\(indexPath.row + 1)  \(rankname[indexPath.row])さん"
        cell.detailTextLabel?.text = "\(rankscore[indexPath.row])pt"
        cell.detailTextLabel?.textColor = UIColor.black
        cell.textLabel!.font = UIFont(name: "takumi-yutorifont-P", size: 21)
        cell.detailTextLabel?.font = UIFont(name: "takumi-yutorifont-P", size: 21)
        cell.backgroundColor = .clear
        return cell
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
