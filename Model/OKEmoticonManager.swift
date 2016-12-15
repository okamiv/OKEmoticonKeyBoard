//
//  OKEmoticonManager.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class OKEmoticonManager {

    static let shareInstance = OKEmoticonManager()
    
    var packages : [OKEmoticonPackage] = [OKEmoticonPackage]()
    
    init() {
        //  添加最近表情的包
        packages.append(OKEmoticonPackage(id: ""))
        
        //  添加默认表情的包
        packages.append(OKEmoticonPackage(id: "com.sina.default"))
        
        //  添加emoji表情的包
        packages.append(OKEmoticonPackage(id: "com.apple.emoji"))
        
        //  添加浪小花表情的包
        packages.append(OKEmoticonPackage(id: "com.sina.lxh"))
    }
    
}
