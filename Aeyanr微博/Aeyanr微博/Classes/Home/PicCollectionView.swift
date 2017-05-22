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
        
    }
}
extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! picCollectionCell
        cell.picURL = picUrls[indexPath.row]
        cell.backgroundColor = UIColor.red
        return cell
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
