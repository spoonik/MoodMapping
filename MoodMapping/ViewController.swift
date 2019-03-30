//
//  ViewController.swift
//  MoodMapping
//
//  Created by spoonik on 2015/10/02.
//  Copyright © 2015年 com.spoonikapps. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var moodripsView: DrawMoodVisual!
    @IBOutlet weak var counts: UILabel!
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var moods: [NSDictionary] = []
    
    let strengthString = ["Faint", "Weak", "Neutral", "Some", "Very"]
    let happyString = ["Dissapointed", "Sad", "Calm", "Joyful", "Happy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // シングルタップ
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
        
        // デリゲートをセット
        tapGesture.delegate = self
        panGesture.delegate = self
        
        // Viewに追加.
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(panGesture)

        // Watchからの送信データを受信するセッションを開始
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }

        //前回の保存内容があるかどうかを判定し読み込み展開
        let userDefaults = NSUserDefaults.standardUserDefaults()
        moods.removeAll()
        if((userDefaults.objectForKey("moodLog")) != nil){
            
            //objectsを配列として確定させ、前回の保存内容を格納
            let objects = userDefaults.objectForKey("moodLog") as? NSArray
            
            //前回の保存内容が格納された配列の中身を一つずつ取り出す
            for mood:AnyObject in objects!{
                let moodDict: NSDictionary = mood as! NSDictionary
              
                //間違ったデータを削除
                let type: Int = moodDict["happy"] as! Int
                if type<0 || (type>4 && (type<101 || type>103)) {
                    continue
                }
              
                moods.append(moodDict)
            }
            
            //テキストの表示
            self.moodripsView.setMoodArray(moods)
            self.displayMoodLogText(nil, last: false)
            
        }

    }
 
    // タップイベント
    func tapGesture(sender: UITapGestureRecognizer){
        self.displayGesture(sender)
    }
    func panGesture(sender: UIPanGestureRecognizer){
        self.displayGesture(sender)
    }
    func displayGesture(sender: UIGestureRecognizer) {
        let cellInfo = moodripsView.getCellInfo(sender.locationInView(moodripsView).x, y: sender.locationInView(moodripsView).y)
        if cellInfo == nil {
            return
        }
        self.displayMoodLogText(cellInfo as NSDictionary!, last: false)
    }
    
    func displayMoodLogText(mood: NSDictionary?, last:Bool) {
        //常にmoodの記録数を表示
        counts.text = String(moods.count) + " marks"
      
        if mood == nil {
            return
        }
        let happyValue = mood!["happy"] as! Int

        //共通の時刻の文字列を生成
        let lastTime = mood!["time"] as? NSTimeInterval
        let date = NSDate(timeIntervalSince1970: lastTime!)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateLabel.text = formatter.stringFromDate(date)


        if (happyValue > 4) {
            //Questの文字列を生成
            switch happyValue {
            case 101:
              happyLabel.text = "Quest achieved!"
            case 102:
              happyLabel.text = "PowerUp used!"
            case 103:
              happyLabel.text = "BadGuy defeated!"
            default:
              happyLabel.text = "unknown mood..."
            }
        }
        else if mood != nil {
            //moodの文字列を生成
            happyLabel.text = strengthString[mood!["strength"] as! Int] + " x " + happyString[mood!["happy"] as! Int]
        }
    }
    

    func session(session: WCSession, didReceiveUserInfo userInfo: [String: AnyObject]) {
        let time = userInfo["time"] as? NSTimeInterval
        let happy = userInfo["happy"] as? Int
        let strength = userInfo["strength"] as? Int
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //新しいキーを追加
        let newDict: NSDictionary = ["time": time! as NSTimeInterval, "happy": happy! as Int, "strength": strength! as Int]
        moods.append(newDict)
        
        //保存
        userDefaults.setObject(moods, forKey:"moodLog")
        userDefaults.synchronize()        // シンクロを入れないとうまく動作しないときが
        
        //新しく受け取った情報を再表示
        self.moodripsView.setMoodArray(moods)
        self.moodripsView.setNeedsDisplay()
        self.displayMoodLogText(moods.last, last: true)
        
    }
    
    // オート回転の禁止
    override func shouldAutorotate() -> Bool{
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

