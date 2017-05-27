//
//  PicCollectionView.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/21.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

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
