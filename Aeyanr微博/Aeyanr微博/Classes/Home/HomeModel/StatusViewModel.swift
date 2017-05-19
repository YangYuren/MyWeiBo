//
//  StatusViewModel.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/19.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    //MARK:- 定义属性
    var status : Status?
    
    //MARK:- 对数据处理属性
    var sourceText : String?
    var createAtText : String?
    var verifiedImage: UIImage?//会员认证
    var vipImage : UIImage? //会员等级
    var profileURL : URL?//处理用户头像的地址
    //MARK:- 自定义构造函数
    init(status : Status) {
        self.status = status
        //对来源处理
        if let source = status.source , status.source != ""{
            let startText = (source as NSString).range(of: ">").location+1
            let length = (source as NSString).range(of: "</a>").location-startText
            sourceText = (source as NSString).substring(with: NSRange(location: startText, length: length))
        }
        //处理时间
        if let creatAt = status.created_at {
            createAtText = Date.createString(creatAtStr: creatAt)
        }
        //处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        //处理会员图标
        let  mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //用户头像处理
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
    }
}
