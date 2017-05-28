//
//  PicCollectionView.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/21.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    //MARK:- 定义属性
    var picUrls : [URL] = [URL]() {
        didSet{
            self.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        
    }
}
extension PicCollectionView : UICollectionViewDataSource ,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! picCollectionCell
        //给cell设置数据
        cell.picURL = picUrls[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo :  [String : Any] = [ShowPhotoBrowerIndexKey: indexPath , ShowPhotoBrowerUrlKey : picUrls]
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: self
            , userInfo: userInfo)
    }
}
class picCollectionCell: UICollectionViewCell {
    //MARK:- 定义模型属性
    var picURL : URL? {
        didSet{
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    @IBOutlet weak var iconView: UIImageView!
}
extension PicCollectionView : AnimatePresentedDelegate{
    func startRect(indexpath : IndexPath) -> CGRect{//开始所在尺寸
        //获取cell
        let cell = self.cellForItem(at: indexpath)!
        //获取cell的frame
        
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        return startFrame
    }
    func endRect(indexpath : IndexPath) -> CGRect{//结束为止
        //获取该位置的image对象
        let picUrl = picUrls[indexpath.item]
        let image = (SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString))!
        //计算结束后的frame
        let width = UIScreen.main.bounds.width
        let height = width / image.size.width * image.size.height
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height{
            y = 0
        }else {
            y = (UIScreen.main.bounds.height - height) / 2
        }
        return CGRect(x: 0, y: y, width: width, height: height)
        
    }
    func imageView(indexPath : IndexPath) -> UIImageView{//零时image
        //创建UIImageView对象
        let imageView = UIImageView()
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString)
        //设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true//超出部分减掉
        //
        return imageView
    }
}
