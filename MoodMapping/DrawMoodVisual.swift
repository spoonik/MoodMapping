//
//  DrawMoodVisual.swift
//  MoodMapping
//
//  Created by spoonik on 2015/10/04.
//  Copyright © 2015年 com.spoonikapps. All rights reserved.
//

import UIKit

class DrawMoodVisual: UIView {
    
    let _linecell: Int = 15     //1行にいくつのセルを表示するかの定数
    
    var moods: [NSDictionary] = []
    
    // ムードの色表現の定数
    let moodColors: [(Int, Int, Int)] = [
        (  0, 150, 255),
        (115, 252, 214),
        (115, 250, 121),
        (255, 224, 121),
        (255, 138, 216)
    ]
    let moodAlphas = [0.6, 0.7, 0.8, 0.9, 1.0]

    
    func setMoodArray(moodarray: [NSDictionary]) {
        moods = moodarray
    }
    
    func getCellInfo(x: CGFloat, y: CGFloat ) -> NSDictionary? {
        let cellwidth = getCellWidth()
        let index = Int(y/cellwidth) * _linecell + Int(x/cellwidth)
        if index >= moods.count || index < 0 {
            return nil
        }
        return moods[moods.count - 1 - index]   // 新しいものから表示するから逆転
    }
    
    override func drawRect(rect: CGRect)
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let cellwidth = getCellWidth()
        var linenum: Int = 0
        var columnnum: Int = 0
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.0)
        
        
        for var index = moods.count-1; index >= 0 ; index-- {   // 新しいものから表示するから逆転
            if cellwidth*CGFloat(columnnum+1) >= width {
                columnnum = 0
                linenum++
                if cellwidth*CGFloat(linenum) >= height {
                    break
                }
            }
            
            let happy = (moods[index]["happy"] as! Int)
            let strength = (moods[index]["strength"] as! Int)
          
            let rectangle = CGRectMake(cellwidth*CGFloat(columnnum),cellwidth*CGFloat(linenum),cellwidth,cellwidth)

            if (happy < moodColors.count && strength < moodAlphas.count) {
              //happyの度合いを色で表示
              CGContextSetRGBFillColor(context,
                  CGFloat(moodColors[happy].0)/CGFloat(255),
                  CGFloat(moodColors[happy].1)/CGFloat(255),
                  CGFloat(moodColors[happy].2)/CGFloat(255),
                  CGFloat(moodAlphas[strength])
              )
              CGContextAddEllipseInRect(context, rectangle)
              CGContextFillPath(context)
              
            }
            else if (happy>=101 && happy<=103) {
              //Questとしてアイコンを表示
              var imageName: String
              switch happy {
              case 101:
                imageName = "Quest"
              case 102:
                imageName = "PowerUp"
              case 103:
                imageName = "BadGuy"
              default:
                continue
              }
              
              let image = UIImage(named: imageName)
              
              UIGraphicsPushContext(context!) //そのまま描画すると上下逆になってしまうので
              image?.drawInRect(rectangle)
              UIGraphicsPopContext()    //これがスマートな逆転描画の方法だった
            }
            
            columnnum++
        }
        
    }
    
    func getCellWidth() -> CGFloat {
        return CGFloat(self.frame.size.width-1)/CGFloat(_linecell)
    }
    
}
