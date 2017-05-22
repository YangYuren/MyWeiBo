//
//  HomeController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage

class HomeController: BaseViewController {
    //MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButtom = TitleButtom()
    fileprivate lazy var popoverAnimate : AYPopoverAnimate  = AYPopoverAnimate { [weak self](presented) in
        self?.titleBtn.isSelected = presented
    }
    lazy var status : [StatusViewModel] = [StatusViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录时候的内容
        visitorView.addRotationAnimate()
        if !isLogin {
            return
        }
        //设置导航栏的内容
        setupNavigationBar()
        //请求数据
        loadStatuses()
        //设计估算高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
    
}
//MARK:- 设置UI界面
extension HomeController {
    fileprivate func setupNavigationBar(){
        //左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //右侧Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //titleButton
        
        titleBtn.setTitle("杨玉仁", for: .normal)
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(HomeController.titleBtnClick(titleBtn:)), for: .touchUpInside)
    }
}
//MARK:- 时间监听函数
extension HomeController {
    @objc fileprivate func titleBtnClick(titleBtn : TitleButtom){
        titleBtn.isSelected = !titleBtn.isSelected
        //设置弹出控制器
        let vc = PopoverViewController()
        //设置model的样式
        vc.modalPresentationStyle = .custom
        //设置转场动画代理
        
        popoverAnimate.presentedFrame = CGRect(x: UIScreen.main.bounds.size.width/4, y: 55, width: 180, height: 240)
        vc.transitioningDelegate = popoverAnimate
        //弹出控制器
        present(vc, animated: true, completion: nil)
    }
}
//MARK:- 请求数据
extension HomeController {
    fileprivate func loadStatuses(){
        NetWorkTools.shareInstance.loadStatus { (result, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //获取可选数据类型
            guard let resultArray = result else {
                return
            }
            //遍历
            for statusDict in resultArray{
                let st = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: st)
                self.status.append(viewModel)
            }
            //缓存图片
            self.cacheImage(viewModels: self.status)
        }
    }
    fileprivate func cacheImage(viewModels : [StatusViewModel]){
        let group = DispatchGroup()//下载完图片再刷新表格
        for viewModel in viewModels{
            for picURL in viewModel.picURLs{
                group.enter()
                SDWebImageManager .shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) { 
            //刷新数据
            self.tableView.reloadData()
        }
    }
}
//MARK:- tableView数据源方法
extension HomeController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeCellId") as! HomeViewCell
        cell.viewModel  = status[indexPath.row]
        return cell
    }
    
}






