//
//  PhotoBrowerController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/25.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

fileprivate let PhotoBrowerCellID = "PhotoBrowerCell"
class PhotoBrowerController: UIViewController {
    //定义属性
    var indexPath : IndexPath
    var picUrls : [URL]
    //懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowerCollectionViewFlowLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.red, fontSize: 14, title: "关闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.red, fontSize: 14, title: "保存")
    //自定义构造函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI界面
        setupUI()
        //滚动到对应图片
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    init(indexPath : IndexPath , picUrls : [URL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置空隙 --------------
//    override func loadView() {
//        super.loadView()
//        view.frame.size.width += 20
//    }
}
//设置UI界面内容
extension PhotoBrowerController {
    fileprivate func setupUI(){
        //添加子空间
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //设置控件frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        //设置collectionView的属性
        collectionView.register(PhotoBrowerCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowerCellID)
        collectionView.dataSource = self
        //监听连个点击按钮
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
    }
}
//设置collectionView数据源方法
extension PhotoBrowerController : UICollectionViewDataSource ,PhotoBrowerCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowerCellID, for: indexPath) as! PhotoBrowerCell
        //cell设置数据
        cell.delegate = self
        cell.picUrl = picUrls[indexPath.row]
        
        return cell
    }
    func imageViewClick() {
        closeClick()
    }
    
}
//监听方法
extension PhotoBrowerController {
    @objc fileprivate func closeClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func saveClick(){
        //保存图片
        let cell = collectionView.visibleCells.first as! PhotoBrowerCell
        guard let image = cell.imageVIew.image else {
            return
        }
        //将image保存相册中
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc fileprivate func image(image : UIImage ,didFinishSavingWithError: NSError? ,contextInfo : Any){
        //保存相册
        var showInfo = ""
        if didFinishSavingWithError != nil {
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}
//MARK:- AnimateDismissdDelegate
extension PhotoBrowerController : AnimateDismissdDelegate{
    func indexPathForDismiss() -> IndexPath{
        //获取当前正在显示的indexpath
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)!
    }
    func imageVeiw() -> UIImageView{
        //创建对象
        let imageView = UIImageView()
        let cell = collectionView.visibleCells.first as! PhotoBrowerCell
        imageView.frame = cell.imageVIew.frame
        imageView.image = cell.imageVIew.image
        //设置属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
//自定义布局
class PhotoBrowerCollectionViewFlowLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //设置itemSize
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //设置滚动方向
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}














