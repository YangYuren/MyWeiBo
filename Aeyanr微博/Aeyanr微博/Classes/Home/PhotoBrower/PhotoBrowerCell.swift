//
//  PhotoBrowerCell.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/25.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage
protocol PhotoBrowerCellDelegate : NSObjectProtocol {
    func imageViewClick()
}
class PhotoBrowerCell: UICollectionViewCell {
    //图片URL
    var picUrl : URL? {
        didSet{
            setupContent(picUrl: picUrl)
        }
    }
    //代理属性
    var delegate : PhotoBrowerCellDelegate?
    //懒加载属性
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageVIew : UIImageView = UIImageView()
    fileprivate lazy var progressView : ProgressVeiw = ProgressVeiw()
    //添加子控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PhotoBrowerCell {
    fileprivate func setupUI(){
        //添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageVIew)
        //设置frame
        scrollView.frame = contentView.bounds
        //frame间隙设置
        //scrollView.frame.size.width -= 20
        
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        //设置控件属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        //监听imageView的点击
        let tag = UITapGestureRecognizer (target: self, action: #selector(imageClick))
        imageVIew.addGestureRecognizer(tag)
        //imageView可以交互
        imageVIew.isUserInteractionEnabled = true
    }
}
//MARK:- 监听事件
extension PhotoBrowerCell {
    @objc fileprivate func imageClick(){
        delegate?.imageViewClick()
    }
}
extension PhotoBrowerCell {
    fileprivate func setupContent(picUrl : URL?){
        guard let picUrl = picUrl else{
            return
        }
        //去除image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: picUrl.absoluteString)
        guard let image1 = image else{
            return
        }
        //计算imageView的frame
        let width = UIScreen.main.bounds.width
        let height = width / image1.size.width * image1.size.height
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height{
            y = 0
        }else {
            y = (UIScreen.main.bounds.height - height) / 2
        }
        imageVIew.frame = CGRect(x: 0, y: y, width: width, height: height)
        //设置imageVeiw图片
        progressView.isHidden = false
        imageVIew.sd_setImage(with: getBigURL(smallURL: picUrl), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current / total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        //设置scrollView的contentsize
        self.scrollView.contentSize = CGSize(width: 0, height: height)
    }
    private func getBigURL(smallURL : URL) -> URL {
        let smallURLstring = smallURL.absoluteString
        //中小图片->bmiddle    超大图->large
        let bigUrlString = smallURLstring.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigUrlString)!
    }
}











