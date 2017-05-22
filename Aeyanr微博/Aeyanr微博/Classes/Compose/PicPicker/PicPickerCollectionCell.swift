//
//  PicPickerCollectionCell.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/22.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class PicPickerCollectionCell: UICollectionViewCell {
    //控件属性
    @IBOutlet weak var btnPicture: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //定义属性
    var image : UIImage?{
        didSet{
            if image != nil {
                imageView.image = image
                btnPicture.isUserInteractionEnabled = false
                delBtn.isHidden = false
            }else{
                imageView.image = nil
                btnPicture.isUserInteractionEnabled = true
                delBtn.isHidden = true
            }
        }
    }
    
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
    }
    
    @IBAction func removePhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
}
