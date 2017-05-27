//
//  HomeController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeController: BaseViewController {
    //MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButtom = TitleButtom()
    fileprivate lazy var popoverAnimate : AYPopoverAnimate  = AYPopoverAnimate { [weak self](presented) in
        self?.titleBtn.isSelected = presented
    }
    fileprivate lazy var tipLabel : UILabel = UILabel()
    lazy var status : [StatusViewModel] = [StatusViewModel]()
    fileprivate lazy var photoTansAnimte : PhotoTransAnimate = PhotoTransAnimate()
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
        //loadStatuses()
        //设计估算高度
        tableView.estimatedRowHeight = 300
        //布局header
        setupHeaderView()
        //布局footerView
        setupFooterView()
        //设置提示labebl
        setupTipLabel()
        //监听通知
        setupNotifications()
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
    fileprivate func setupHeaderView(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        //设置header属性
        header?.setTitle("下拉属性", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        //设置tableView的header 
        tableView.mj_header = header
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    fileprivate func setupFooterView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatus))
    }
    //初始化tipLabel
    fileprivate func setupTipLabel(){
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 34)
        //设置label属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    //注册通知
    fileprivate func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPhoto(notification:)), name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: nil)
    }
}
//MARK:- 事件监听函数
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
    //展示图片
    @objc fileprivate func showPhoto(notification : Notification){
        //取出数据
        let indexPath = notification.userInfo![ShowPhotoBrowerIndexKey] as! IndexPath
        let picUrls = notification.userInfo![ShowPhotoBrowerUrlKey] as! [URL]
        //创建控制器
        let photo =  PhotoBrowerController(indexPath: indexPath, picUrls: picUrls)
        //设置model的形式
        photo.modalPresentationStyle = .custom
        //自定义转场动画
        photo.transitioningDelegate = photoTansAnimte
        //以modle的形式弹出
        present(photo, animated: true, completion: nil)
    }
}
//MARK:- 请求数据
extension HomeController {
    fileprivate func loadStatuses(isNewData : Bool){
        //获取sinceId   抓取最新微博
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = status.first?.status?.mid ?? 0
        }else{
            max_id = status.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        NetWorkTools.shareInstance.loadStatus(since_id: since_id, max_id: max_id) { (result, error) in
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
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray{
                let st = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: st)
                tempViewModel.append(viewModel)
            }
            if isNewData {
                self.status = tempViewModel + self.status
            }else{
                self.status = self.status + tempViewModel
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
            //结束刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            //显示提示label 
            self.showTipLabel(count: self.status.count)
        }
    }
    //显示提示label
    fileprivate func showTipLabel(count : Int){
        //设置tipLabel属性
        self.tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有数据" : "\(count) 条微博"
        //执行动画
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
    //加载最新数据
    @objc fileprivate func loadNewData(){
        //调用数据
        loadStatuses(isNewData : true)
    }
    //加载更多数据
    @objc fileprivate func loadMoreStatus(){
        //调用数据
        loadStatuses(isNewData : false)
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return status[indexPath.row].cellHeight
    }
}







