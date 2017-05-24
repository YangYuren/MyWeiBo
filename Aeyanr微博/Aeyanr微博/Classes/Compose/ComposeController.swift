//
//  ComposeController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/22.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class ComposeController: UIViewController{
    //控件属性
    @IBOutlet weak var CtextView: ComposeTextView!//文本输入框属性
    @IBOutlet weak var pickerVeiw: PicPickerCollection!//collectionView属性
    //懒加载属性
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images : [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVC : EmoticonController = EmoticonController { [weak self](emoticon) in
        self?.CtextView.insertEmoticon(emoticon : emoticon)
        self?.textViewDidChange(self!.CtextView)
    }
    //约束属性
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerVeiwCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setupNavBar()
        //通知
        setupNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CtextView.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//设置UI界面
extension ComposeController {
    fileprivate func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(send))
        navigationItem.rightBarButtonItem?.isEnabled = false
        //设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    fileprivate func setupNotification(){
        //监听通知键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillShow(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
        //监听添加照片
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoBtnClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //监听删除照片
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoBtnClick(note:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}
//添加照片与删除照片事件
extension ComposeController {
    @objc fileprivate func addPhotoBtnClick(){
        //判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            return
        }
        //创建照片选择控制器
        let ipc = UIImagePickerController()
        //设置照片源
        ipc.sourceType = .photoLibrary
        //设置代理
        ipc.delegate = self
        //弹出照片选择控制器
        present(ipc, animated: true, completion: nil)
    }
    @objc fileprivate func removePhotoBtnClick(note : NSNotification){
        guard let image = note.object as? UIImage else{
            return
        }
        //获取image对象所在下表
        guard let index = images.index(of: image) else{
            return
        }
        images.remove(at: index)
        //重新复制
        pickerVeiw.images = images
        
    }
}
//照片选择代理方法
extension ComposeController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选中照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //展示照片
        images.append(image)
        //让collection自己展示数据
        pickerVeiw.images = images
        //退出控制器
        picker.dismiss(animated: true, completion: nil)
    }
}
//事件监听
extension ComposeController {
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func send(){
        print(CtextView.getEmoticonString())
    }
    @objc fileprivate func UIKeyboardWillShow(note : Notification){
        let durarion = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        //获取键盘最终的y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //距离工具栏距离底部间距
        let marginY = UIScreen.main.bounds.height - y
        //执行动画
        bottomCons.constant = marginY
        UIView.animate(withDuration: durarion) { 
            self.view.layoutIfNeeded()
        }
        
    }
    @IBAction func picPicker() {
        //退出键盘
        CtextView.resignFirstResponder()
        //执行动画
        picPickerVeiwCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func emoticonBtnClick(){
        //退出键盘
        CtextView.resignFirstResponder()
        //切换键盘
        CtextView.inputView = CtextView.inputView != nil ? nil : emoticonVC.view
        //弹出键盘
        CtextView.becomeFirstResponder()
    }
}
//UITextViewDelegate方法
extension ComposeController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {// UITextView发生改变调用
        self.CtextView.placeHolderlabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.CtextView.resignFirstResponder()
    }
}
