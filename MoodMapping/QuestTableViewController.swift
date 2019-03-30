//
//  QuestTableViewController.swift
//  moodrips
//
//  Created by spoonik on 2016/01/24.
//  Copyright © 2016年 com.spoonikapps. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

class QuestTableViewController: UITableViewController , MyViewDelegate, WCSessionDelegate {

    @IBOutlet var questTable: UITableView!
    var questEntities: NSMutableArray?
  
    @IBAction func done(sender: AnyObject) {
        //前の画面に戻る
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        //前回の保存内容があるかどうかを判定し読み込み展開
        let userDefaults = NSUserDefaults(suiteName: "group.com.spoonikapps.MoodMapping")
        let entities: NSArray? = userDefaults?.objectForKey("quests") as? NSArray
        if entities == nil {
            questEntities = NSMutableArray()
        } else {
            questEntities = entities?.mutableCopy() as? NSMutableArray
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      
        //テーブルの罫線の表示が切れる現象を回避
        if self.tableView.respondsToSelector("separatorInset") {
            self.tableView.separatorInset = UIEdgeInsetsZero;
        }
        if self.tableView.respondsToSelector("layoutMargins") {
            self.tableView.layoutMargins = UIEdgeInsetsZero;
        }

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return questEntities!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestsTableCell")! as UITableViewCell
      
        if (questEntities == nil) {
            return cell
        }

        //表示するテキストとイメージの指定
        cell.textLabel!.text = questEntities?.objectAtIndex(indexPath.section)["action"] as? String
      
        //イメージはちょっと縮小して表示
        let img_bf: UIImage = UIImage(named: (questEntities?.objectAtIndex(indexPath.section)["type"] as? String)!)!
        let width: CGFloat = 30//img_bf.size.width * 0.5
        let height: CGFloat = 30//img_bf.size.height * 0.5
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        img_bf.drawInRect(CGRectMake(0, 0, width, height))
        let img_af: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.imageView?.image = img_af
        //cell.imageView?.image = UIImage(named: (questEntities?.objectAtIndex(indexPath.section)["type"] as? String)!)
      
      
        //テーブルの罫線の表示が切れる現象を回避
        if cell.respondsToSelector("separatorInset") {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        if cell.respondsToSelector("preservesSuperviewLayoutMargins") {
            cell.preservesSuperviewLayoutMargins = false;
        }
        if cell.respondsToSelector("layoutMargins") {
            cell.layoutMargins = UIEdgeInsetsZero;
        }

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
          
            //questsリストから削除して再表示
            questEntities?.removeObjectAtIndex(indexPath.section)
          
            saveQuestList()
          
            self.tableView.reloadData()
          
        //} else if editingStyle == .Insert {
        //    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "questSegue") {
            // SecondViewControllerクラスをインスタンス化してsegue（画面遷移）で値を渡せるようにバンドルする
            let secondView : QuestDetailViewController = segue.destinationViewController as! QuestDetailViewController
            // secondView（バンドルされた変数）に受け取り用の変数を引数とし_paramを渡す（_paramには渡したい値）
            // この時SecondViewControllerにて受け取る同型の変数を用意しておかないとエラーになる
            secondView._second = "new action"
            secondView.delegate = self
        }

    }
    /*
     * SecondViewから戻ってきた時の処理
     */
    // Called and receive data from detail table view
    func finishSelection(selectedItemId: NSDictionary) {
        //新しいキーを追加して保存
        questEntities?.addObject(selectedItemId as! Dictionary<String, AnyObject>)
      
        saveQuestList()
      
        self.tableView.reloadData()
        
        NSLog("Selected is \(selectedItemId)")
    }
  
    //自分のDBに新しいクエストリストを保存
    func saveQuestList() {
        let userDefaults = NSUserDefaults(suiteName: "group.com.spoonikapps.MoodMapping")
        let newEntities: NSArray = (questEntities?.copy())! as! NSArray
        userDefaults?.setObject(newEntities, forKey: "quests")
        userDefaults?.synchronize()
      
        // Watchへクエストリストのデータを送信開始
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            let olddelegate:WCSessionDelegate  = session.delegate!
            session.delegate = self
            session.activateSession()
            let message = ["quests": newEntities as AnyObject]
            WCSession.defaultSession().transferUserInfo(message )
            session.delegate = olddelegate
        }
    }

}
