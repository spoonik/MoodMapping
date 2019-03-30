//
//  InterfaceController.swift
//  MoodMapping WatchKit Extension
//
//  Created by spoonik on 2015/10/02.
//  Copyright © 2015年 com.spoonikapps. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let moodAlphas: [CGFloat] = [0.6, 0.8, 1.0]

    @IBOutlet weak var happyPicker: WKInterfacePicker!
    @IBOutlet var moodBtn: WKInterfaceButton!
    @IBOutlet var mapBtn: WKInterfaceButton!
  
    let kisuu: Int = 3
    var happy: Int = 3
    var strength: Int = 3
    
    var pickerItems1: [WKPickerItem]! = []
    var pickerItems2: [WKPickerItem]! = []
    var happyImages: [UIImage]! = []
    var gaugeImages: [UIImage]! = []

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }

        for (var i=0; i<=kisuu*5; i++) {
            let pickerItem = WKPickerItem()
            let imageName = "happy-\(Int(i/kisuu))"
            let image = WKImage(imageName: imageName)
            pickerItem.contentImage = image
            pickerItems1.append(pickerItem)
        }
      
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        happyPicker.setItems(pickerItems1)
        happyPicker.setSelectedItemIndex(Int((kisuu*5)/2))

    }
    
    @IBAction func happyPickerChanged(value: Int) {
        happy = Int(value/kisuu)
        strength = value%kisuu
        if (happy<5) {
          self.happyPicker.setAlpha(self.moodAlphas[value%kisuu])
        }
        else {
          self.happyPicker.setAlpha(0.9)
        }
    }

    // 送信ダイアログ
    @IBAction func recordCurrentMood() {
        WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Success)


        // moodをiPhoneにWCSessionを使って送信
        let now = NSDate()
        let dateUnix = now.timeIntervalSince1970
        if (WCSession.isSupported()) {
            var message = ["time": dateUnix, "happy": happy, "strength": strength]
            if (happy<5) {
              WCSession.defaultSession().transferUserInfo(message as! [String: AnyObject])
            } else {
              message = ["time": dateUnix, "happy": 102, "strength": 0]
              WCSession.defaultSession().transferUserInfo(message as! [String: AnyObject])
            }
        }
    }
    

    // Force Touch メニューで呼び出される「深呼吸」メニュー
    @IBAction func pushBreathe() {
        self.presentControllerWithName("BreathePanel", context: self)
    }

    // Force Touch メニューで呼び出される「ライフハック」メニュー
    @IBAction func pushSuperBetter() {
        let filePath = NSBundle.mainBundle().pathForResource("Data.plist", ofType:nil )
        let dic = NSDictionary(contentsOfFile:filePath!)
        let list = dic?.objectForKey("Strategies") as! NSArray

        //乱数発生
        let n = Int(arc4random_uniform(UInt32(list.count)))
        let oneDic = list.objectAtIndex(n)
        
        //ダイアログ表示
        let buttonAction = WKAlertAction(title:"Love it ❤️", style: .Default) { () -> Void in
            // ボタンが押された時の処理
        }
        presentAlertControllerWithTitle(oneDic["title"] as? String, message:oneDic["line"] as? String, preferredStyle: .Alert, actions: [buttonAction]);
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
