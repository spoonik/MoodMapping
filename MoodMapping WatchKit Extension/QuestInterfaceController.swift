//
//  QuestInterfaceController.swift
//  moodrips
//
//  Created by spoonik on 2016/01/23.
//  Copyright © 2016年 com.spoonikapps. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class QuestInterfaceController: WKInterfaceController, WCSessionDelegate {

    var pickerItems: [WKPickerItem]! = []
    var questsList: NSArray?
    @IBOutlet var questsPicker: WKInterfacePicker!
    var selectedQuest: Int = 0
  
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
      
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }

        //前回の保存内容があるかどうかを判定し読み込み展開
        let userDefaults = NSUserDefaults(suiteName: "group.com.spoonikapps.MoodMapping")
        questsList = userDefaults?.objectForKey("quests") as? NSArray
        if questsList == nil {
            questsList = NSArray()
        }
      
        //Pickerに表示
        updateQuestsList()

    }

    func session(session: WCSession, didReceiveUserInfo userInfo: [String: AnyObject]) {
        //iPhone側でアップデートされたquestリストを受け取り、自分のUserDefaultsに保存しておく
        questsList = userInfo["quests"] as? NSArray
      
        let userDefaults = NSUserDefaults(suiteName: "group.com.spoonikapps.MoodMapping")
        userDefaults?.setObject(questsList, forKey: "quests")
        userDefaults?.synchronize()

        //Pickerに表示
        updateQuestsList()
    }
  
    func updateQuestsList() {
        pickerItems.removeAll()
        for (var i=0; i<questsList!.count; i++) {
            let oneDic = questsList!.objectAtIndex(i)
            let pickerItem = WKPickerItem()
            let image = WKImage(imageName: (oneDic["type"] as? String)!)
            
            pickerItem.title = (oneDic["action"] as? String)!
            pickerItem.accessoryImage = image
            pickerItems.append(pickerItem)
        }

        if questsList!.count==0 {
            let pickerItem = WKPickerItem()
            pickerItem.title = "Add Quests"
            pickerItems.append(pickerItem)
        }
    }

    //Pickerで選択が変化
    @IBAction func questPickerChanged(value: Int) {
        selectedQuest = value
    }

    //クエストを選んで実行「Done」ボタンを押す
    @IBAction func questDone() {
        if (questsList!.count <= 0) {
          return
        }
      
        let now = NSDate()
        let dateUnix = now.timeIntervalSince1970
        var questType: Int
        switch (questsList![selectedQuest]["type"] as! String) {
        case "Quest":
          questType = 101
        case "PowerUp":
          questType = 102
        case "BadGuy":
          questType = 103
        default:
          return
        }
      
        if (WCSession.isSupported()) {
            let message = ["time": dateUnix, "happy": questType, "strength": 0/*questsList![selectedQuest]["id"]*/]
            WCSession.defaultSession().transferUserInfo(message as! [String: AnyObject])
            print(message)
        }
      
        WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Success)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
      
        questsPicker.setItems(pickerItems)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
