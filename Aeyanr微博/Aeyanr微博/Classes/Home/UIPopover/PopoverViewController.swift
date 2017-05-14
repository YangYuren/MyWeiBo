//
//  PopoverViewController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/14.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var PopoverimageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置图片拉伸
        let image = UIImage(named: "popover_background")?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 0, 20, 0), resizingMode: UIImageResizingMode.stretch)
        PopoverimageView.image = image
    }
}
