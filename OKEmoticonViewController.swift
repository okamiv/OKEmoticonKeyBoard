//
//  OKEmoticonViewController.swift
//  集成表情键盘
//
//  Created by Okami on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OKEmoticonCell"

class OKEmoticonViewController: UIViewController {

    var emoticonCallBack : (_ emoticon : OKEmoticon) -> ()

    var selectedEmoticon : OKEmoticon?
    
    // MARK: - 控件
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    
    fileprivate lazy var manager : OKEmoticonManager = OKEmoticonManager()
    
    // MARK: - 自定义构造函数
    init(emoticonCallBack : @escaping (_ emoticon : OKEmoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension OKEmoticonViewController {
    
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.lightGray
        toolBar.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["collectionView" : collectionView, "toolBar" : toolBar] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        
        preparForCollection()
        preparForToolBar()
        
    }
    
    fileprivate func preparForCollection() {
        collectionView.register(OKEmoticonCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func preparForToolBar() {
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        var index = 0
        var tempitems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemOnClick(item:)))
           item.tag = index
            index += 1
            
            tempitems.append(item)
            tempitems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        tempitems.removeLast()
        toolBar.items = tempitems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc fileprivate func itemOnClick(item : UIBarButtonItem) {
        // 滚动到对应位置
        let tag = item.tag
        let indexPath = NSIndexPath(item: 0, section: tag)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
    }
    
}
// MARK: - collectionViewe的代理方法和数据源方法
extension OKEmoticonViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OKEmoticonCell
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        // 将选中的表情加入到最近分组
        insertEmoticonToRecently(emoticon: emoticon)
        
        // 将选中的表情传递给你外界的控制器
        emoticonCallBack(emoticon)
    }
}

extension OKEmoticonViewController {
    /// 将表情插入到最近分组
    fileprivate func insertEmoticonToRecently(emoticon : OKEmoticon) {
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        if manager.packages.first!.emoticons.contains(emoticon) {
           let index = manager.packages.first?.emoticons.index(of: emoticon)
            manager.packages.first?.emoticons.remove(at: index!)
        } else {
            manager.packages.first?.emoticons.remove(at: 19)
        }
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}


class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemWH = UIScreen.main.bounds.size.width / 7
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 调整那边距
        let margin : CGFloat = ((collectionView?.bounds.height)! - 3 * itemWH) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
    }
}
