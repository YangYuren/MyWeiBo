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
    @IBOutlet weak var picViewHCon: NSLayoutConstraint!
    @IBOutlet weak var picViewWCon: NSLayoutConstraint!
    
    //MARK:- 空间属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contenLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetLabel: UILabel!
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
            //计算picView的宽度与高度
            let picViewSize = calculateSize(count: viewModel.picURLs.count)
            picViewHCon.constant = picViewSize.height
            picViewWCon.constant = picViewSize.width
            //将picURL的数据传给picView
            picView.picUrls = viewModel.picURLs
            //设置正文数据
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name , let retweetText = viewModel.status?.retweeted_status?.text {
                    retweetLabel.text = "@" + "\(screenName):" + "\(retweetText)"
                }
            }else{
                retweetLabel.text = nil
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文宽度约束
        ContentLabelWith.constant = UIScreen.main.bounds.width - 2*edgeMargin
    }
}
extension HomeViewCell {
    //计算picView的高度宽度
    fileprivate func calculateSize(count : Int) -> CGSize{
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //没有配图
        if count == 0 {
            return CGSize(width: 0, height: 0)
        }
        //取出picView的layout
        
        /*if count == 1 {
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: (viewModel?.picURLs.last?.absoluteString)!)
            layout.itemSize = CGSize(width: (image?.size.width)!*2, height: (image?.size.height)!*2)
            return CGSize(width: (image?.size.width)!*2, height: (image?.size.height)!*2)
        }*/
        
        //计算imageView的宽度高度
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        //4张图片
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //其他张图片
        //计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}

















