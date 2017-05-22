//
//  PicPickerCollection.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/22.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

fileprivate let picPickerCell = "CellId"
class PicPickerCollection: UICollectionView {
    //定义属性
    var images : [UIImage] = [UIImage](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置布局
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * itemMargin)/3
        layout.minimumLineSpacing = itemMargin
        layout.minimumInteritemSpacing = itemMargin
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        //注册cell
        //register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: picPickerCell)
        let nib = UINib(nibName: "PicPickerCollectionCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: picPickerCell)//注册nib
        
        dataSource = self
        //设置内边距
        contentInset = UIEdgeInsets(top: itemMargin, left: itemMargin, bottom: 0, right: itemMargin)
    }

}
extension PicPickerCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerCollectionCell
        //给cell设置数据
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.row] : nil
        return cell
    }
}
