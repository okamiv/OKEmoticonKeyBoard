//
//  OKEmoticonModel.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class OKEmoticon: NSObject {

    var code : String? {    // emoji的code
        didSet {
            guard let code = code else {
                return
            }
            // 创建扫描器
            let scanner = Scanner(string: code)
            // 调用方法，扫描成code中的值
            var value : uint = 0
            scanner.scanHexInt32(&value)
            // 将value转成字符
            let c = Character(UnicodeScalar(value)!)
            // 将字符转成字符串
            emojiCode = String(c)
        }
    }
    
    var png : String? {
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    
    var chs : String?
    
    
    // MARK: - 属性
    var isEmpty : Bool = false
    var isRemove : Bool = false
    
    var pngPath : String?
    var emojiCode : String?
    
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    
    
}
