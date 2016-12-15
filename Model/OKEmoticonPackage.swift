//
//  OKEmoticonPackage.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class OKEmoticonPackage: NSObject {

    var emoticons : [OKEmoticon] = [OKEmoticon]()
    
    init(id : String) {
        super.init()
        // 最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        // indo.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info", ofType: "plist", inDirectory: "Emoticons.bundle")!
        
        // 读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        
        // 遍历数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(OKEmoticon(dict: dict))
            index += 1
            
            if index == 20 {
                emoticons.append(OKEmoticon(isRemove: true))
                index = 0
            }
        }
        // 添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
    fileprivate func addEmptyEmoticon(isRecently : Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(OKEmoticon(isEmpty: true))
        }
        emoticons.append(OKEmoticon(isRemove: true))
    }
}
