//
//  OKEnoticonCell.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class OKEmoticonCell: UICollectionViewCell {
    
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    
    var emoticon : OKEmoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OKEmoticonCell {
    fileprivate func setupUI() {
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonBtn.isUserInteractionEnabled = false
    }
}
