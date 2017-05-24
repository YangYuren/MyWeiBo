//
//  EmoticonController.swift
//  textView测试
//
//  Created by Yang on 2017/5/23.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
fileprivate let emoticonCell = "emoticonCell"

class EmoticonController: UIViewController {
    //定义属性
    var emoticonBlock :( _ emoticon : Emoticon)->()
    //懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    fileprivate lazy var manager = EmoticonManager()
    //MARK:- 自定义构造函数
    init(emoticonBlock : @escaping ( _ emoticon : Emoticon) -> ()) {
        self.emoticonBlock = emoticonBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
//设置UI界面
extension EmoticonController {
    fileprivate func  setupUI(){
        //添加子空间
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        toolBar.backgroundColor = UIColor(white: 1, alpha: 1)
        //设置子空间frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views : [String : Any] = ["toolBar" : toolBar , "collectionView" : collectionView]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        //准备collectionView 
        prepareForCollectionView()
        //准备toolBar
        prepareForToolBar()
    }
    //collectionView  注册cell
    private func prepareForCollectionView(){
        collectionView.register(EmoticonViewCell.classForCoder(), forCellWithReuseIdentifier: emoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    //toolBar
    private func prepareForToolBar(){
        let titles = ["最近","默认","emoji","浪小花"]
        var index = 0
        var items = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()//去除最后一个弹簧
        toolBar.items = items
        toolBar.tintColor = UIColor.orange
    }
    @objc fileprivate func itemClick(item : UIBarButtonItem){
        //获取item的tag
        let tag = item.tag
        //根据tag获取当前组
        let indexPath = NSIndexPath(item: 0, section: tag)
        //直接滚动到indexPath
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
    }
}
//数据源方法
extension EmoticonController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCell, for: indexPath) as! EmoticonViewCell
        //展示数据
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
}
//collectionView代理方法
extension EmoticonController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //去除点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //将点击的表情插入最近中
        insertRecentlyEmoticon(emoticon: emoticon)
        //表情包回调
        emoticonBlock(emoticon)
    }
    //插入操作
    private func insertRecentlyEmoticon(emoticon : Emoticon){
        //如果是空白表情或者删除按钮不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        //删除表情
        if manager.packages.first!.emoticons.contains(emoticon){
            //该表情存在  就删除原来位置的表情
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        }else{
            //源来没有这个表情  判断表情个数书否超过20
            if manager.packages.first?.emoticons.count == 21 {
                manager.packages.first?.emoticons.remove(at: 19)
            }
        }
        //添加进入最近
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}
//自定义流布局
class EmoticonCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //计算itemSize 
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        //设置分页
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        //设置内边距
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}


















