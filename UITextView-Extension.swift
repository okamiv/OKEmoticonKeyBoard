//
//  UITextView-Extension.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

extension UITextView {
    
    func insertEmoticon(emoticon : OKEmoticon) {
        if  emoticon.isEmpty {
            return
        }
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        if emoticon.emojiCode != nil {
            // emoji表情
            let textRange = selectedTextRange!
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        // 普通表情
        let attachment = OKEmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        
        let attrImageStr = NSAttributedString(attachment: attachment)
        let attrMstr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMstr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMstr
        
        self.font = font
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }

    func getEmoticonString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? OKEmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMStr.string
    }
}
