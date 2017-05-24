//
//  EmoticonViewCell.swift
//  textView测试
//
//  Created by Yang on 2017/5/23.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //懒加载子控件
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    //定义属性
    var emoticon : Emoticon?{
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            //设置emmoticonBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile:emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            //设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named:"compose_emotion_delete"), for: .normal)
            }
        }
    }
    //重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:- 设置UI界面
extension EmoticonViewCell {
    fileprivate func setupUI(){
        //添加子控件
        contentView.addSubview(emoticonBtn)
        //这只frame
        emoticonBtn.frame = contentView.bounds
        //设置btn属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
