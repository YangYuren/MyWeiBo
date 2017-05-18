//
//  AYOAuthViewController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/17.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SVProgressHUD

class AYOAuthViewController: UIViewController {
    @IBOutlet weak var oAuthView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏内容
        setupNavigationBar()
        //加载网页
        //oAuthView.loadRequest(URLRequest(url: URL(string : "http://www.baidu.com")!))
        loadPage()
    }
}
//MARK:- 设置UI界面相关
extension AYOAuthViewController {
    fileprivate func setupNavigationBar(){
        //设置左边item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(AYOAuthViewController.close))
        //设置右边item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(AYOAuthViewController.fill))
        //设置标题
        title = "登录页面"
    }
    fileprivate func loadPage(){
        //获取登录界面URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        //创建对应的NSURL
        guard let url = URL(string: urlString) else {
            return
        }
        //创建URLRequest
        let request = URLRequest(url: url)
        oAuthView.loadRequest(request)
    }
}
//MARK:- 时间监听函数
extension AYOAuthViewController {
    @objc fileprivate func close(){
        self .dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func fill(){
        //书写js代码
        let jsCode = "document.getElementById('userId').value='17601472402';document.getElementById('passwd').value='Yang082194'";
        //执行js代码
        oAuthView.stringByEvaluatingJavaScript(from: jsCode)
    }
}
//MARK:- webView的delegate方法
extension AYOAuthViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show(withStatus: "开始加载网页")
    }
    //加载完诚
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    //网页加载网页失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //准备加载某个网页时，会执行该方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获取加载网页的URL
        guard let url = request.url else {
            return true
        }
        //获取url中的sring
        let urlString = url.absoluteString
        //判断该字符串是否包含code=
        guard urlString.contains("code=")else {
            return true
        }
        //将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        //请求accessToken
        loadAccessToken(code: code)
        return false
    }
}
//MARK:-  请求数据Accesstoken
extension AYOAuthViewController {
    fileprivate func loadAccessToken(code : String){
        NetWorkTools.shareInstance.loadAccessTools(code: code) { ( result, error) in
            if error != nil{
                print(error!)
                return
            }
            guard let accountDict = result else{
                return
            }
            //将字典转为模型
            let account = UserAccount(dict: accountDict)
            //请求用户信息
            self.loaduserInfo(account: account)
        }
    }
    //请求用户信息
    fileprivate func loaduserInfo(account : UserAccount){
        //获取accessToken
        guard let access_token = account.access_token else {
            return
        }
        //获取uid
        guard let uid = account.uid else {
            return
        }
        //发送网路请求
        NetWorkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result, error) in
            if error != nil{
                print(error!)
                return
            }
            guard let userInfo = result else{
                return
            }
            //从字典中中选出昵称与头像
            account.screen_name = userInfo["screen_name"] as? String
            account.avatar_large = userInfo["avatar_large"] as? String
            //将account对象保存起来
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareInstance.accountPath)
            //将account设置到单例对象中
            UserAccountViewModel.shareInstance.account = account
            //退出控制器
           self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = AYWelcomeController()
            })
        }
    }
}
