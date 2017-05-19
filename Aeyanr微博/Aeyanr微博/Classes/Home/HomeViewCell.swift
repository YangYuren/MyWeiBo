//
//  HomeViewCell.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/19.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage
class HomeViewCell: UITableViewCell {
    //MARK:- 约束属性
    @IBOutlet weak var ContentLabelWith: NSLayoutConstraint!
    //MARK:- 空间属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contenLabel: UILabel!
    //MARK:- 定义属性
    var viewModel : StatusViewModel?{
        didSet{
            //空值校验
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //设置认证图标
            verifiedView.image = viewModel.verifiedImage
            //昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //会员图标
            vipView.image = viewModel.vipImage
            //时间
            timeLabel.text = viewModel.createAtText
            //来源
            sourceLabel.text = viewModel.sourceText
            //微博正文
            contenLabel.text = viewModel.status?.text
            //设置昵称颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文宽度约束
        ContentLabelWith.constant = UIScreen.main.bounds.width - 2*edgeMargin
    }
}
