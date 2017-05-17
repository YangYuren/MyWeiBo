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
        let jsCode = "document.getElementById('userId').value='17601472402';document.getElementById('passwd').value='yyr10086'";
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
        guard let url = request.url else {
            return true
        }
        //获取url中的sring
        let urlString = url.absoluteString
        guard urlString.contains("code=")else {
            return true
        }
        let code = urlString.components(separatedBy: "code=").last!
        //直接结束
        print(code)
        return false
    }
}
